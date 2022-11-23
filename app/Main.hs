{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where
import           Cardano.Api
import           Canonical.Multisig
import           Options.Generic

data Options = Options
  { outputFile :: FilePath
  }
  deriving(Generic)

fieldModifier :: Modifiers
fieldModifier = lispCaseModifiers
  { fieldNameModifier = fieldNameModifier lispCaseModifiers
  }

instance ParseRecord Options where
  parseRecord = parseRecordWithModifiers fieldModifier

main :: IO ()
main = run =<< getRecord "Multisig Compiler"

run :: Options -> IO ()
run Options {..} = writeSC outputFile

writeSC :: FilePath -> IO ()
writeSC output = do
  result <- writeFileTextEnvelope output Nothing multisig
  case result of
    Left err -> print $ displayError err
    Right () -> putStrLn $ "wrote validator to file " ++ output
