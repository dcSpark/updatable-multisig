{-# LANGUAGE NoImplicitPrelude #-}

module Canonical.Multisig
  ( multisig
  , Input(..)
  ) where

import           Cardano.Api.Shelley (PlutusScript (..), PlutusScriptV2)
import           Codec.Serialise
import qualified Data.ByteString.Lazy as LB
import qualified Data.ByteString.Short as SBS
import           Plutus.V2.Ledger.Contexts
import           Plutus.V1.Ledger.Scripts
import           Plutus.V1.Ledger.Crypto
import           Plutus.V2.Ledger.Tx
import           PlutusTx
import           PlutusTx.Prelude hiding (Semigroup (..), unless)
import qualified Plutonomy

data Input = Input
  { iRequiredCount :: Integer
  , iKeys          :: [PubKeyHash]
  }

data Action = Update | Close

unstableMakeIsData ''Input
unstableMakeIsData ''Action

signedByAMajority :: [PubKeyHash] -> Integer -> [PubKeyHash] -> Bool
signedByAMajority allKeys requiredCount signingKeys
  = length (filter (`elem` allKeys) signingKeys) >= requiredCount

mkValidator :: Input -> Action -> ScriptContext -> Bool
mkValidator
  Input { iRequiredCount = oldRequiredCount
        , iKeys = oldKeys
        }
  action
  ctx@ScriptContext{ scriptContextTxInfo = info@TxInfo{..}} = case action of
    Close -> traceIfFalse
      "Not enough valid signatures"
      (signedByAMajority oldKeys oldRequiredCount txInfoSignatories)
    Update ->
      let
        theOutDatum :: OutputDatum
        !theOutDatum = case getContinuingOutputs ctx of
          [TxOut{txOutDatum}] -> txOutDatum
          _ -> traceError "expected exactly one continuing output"

        Input {iRequiredCount = newRequiredCount, iKeys = newKeys} = case theOutDatum of
          OutputDatum (Datum dbs) -> unsafeFromBuiltinData dbs
          OutputDatumHash dh -> case findDatum dh info of
            Nothing -> traceError "datum not found"
            Just (Datum d) -> unsafeFromBuiltinData d
          NoOutputDatum -> traceError "Missing Datum Hash"

        newKeyCount :: Integer
        !newKeyCount = length newKeys

        newInputIsValid :: Bool
        !newInputIsValid
          =  newKeyCount > 0
          && newRequiredCount <= newKeyCount
          && newRequiredCount > 0

        hasEnoughSignatures :: Bool
        !hasEnoughSignatures =
          signedByAMajority oldKeys oldRequiredCount txInfoSignatories

      in traceIfFalse "Not enough valid signatures" hasEnoughSignatures
      && traceIfFalse "New datum is invalid"        newInputIsValid

-------------------------------------------------------------------------------
-- Boilerplate
-------------------------------------------------------------------------------
wrapValidator
    :: BuiltinData
    -> BuiltinData
    -> BuiltinData
    -> ()
wrapValidator a b c
  = check (mkValidator (unsafeFromBuiltinData a) (unsafeFromBuiltinData b) (unsafeFromBuiltinData c))

validator :: Validator
validator = Plutonomy.optimizeUPLC $ mkValidatorScript $
    $$(compile [|| wrapValidator ||])

-------------------------------------------------------------------------------
-- Entry point
-------------------------------------------------------------------------------
multisig :: PlutusScript PlutusScriptV2
multisig
  = PlutusScriptSerialised
  . SBS.toShort
  . LB.toStrict
  $ serialise
    validator
