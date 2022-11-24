# Updateable Multisig Contract

# Usage

This smart contract is a generalization of "n of m" multisig native script addresses. Unlike traditionally multisig addresses, when unlocking, the set of signing keys and the required count of signing keys can be updated.

## Locking

When locking funds at the smart contract address, users will provide a datum which is deserialized to the following Haskell type:
```haskell
data Input = Input
  { iRequiredCount :: Integer
  , iKeys          :: [PubKeyHash]
  }
```

The `iRequiredCount` count says how many keys are required to unlock the funds. The `iKeys` list the public key hashes for the users who can potentially sign to unlock the funds.

### ⚠️ Warning

When locking funds, one needs to ensure the datum is properly configured, otherwise the funds could be locked forever. Specifically, the following conditions should be met:

1. The `iKeys` list is non-empty.
2. There are no duplicates in the `iKeys` list.
3. The `iRequiredCount` is less than or equal to the length of the `iKeys` array.

## Updating

The `Update` redeemer is used to update the signing keys and required count of keys. To successfully update, enough current signing keys must be present in the transaction, as specified by the datum. Additionally, a new datum must be provided. Unlike when initially locking, the new datum will be validated to ensure it is valid.

## Closing

To completely remove all the assets, use the `Close` redeemer. The `Close` redeemer checks for the presence of the enough valid signing keys, like `Update`. However, unlike `Update`, it does not check for a new datum for unlocking future funds.

# Assets

The compiled Plutus script is checked in to the following location: `assets/multisig.plutus`

Testnet and mainnet assets are checked i

# Compiling

Compliation has been validated with GHC 8.10.7.

To compile call the compile script:

```bash
./scripts/compile
```
