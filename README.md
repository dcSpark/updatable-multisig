# Updateable Multisig Contract

This smart contract is a generalization of "n of m" multisig native script addresses. Unlike traditionally multisig addresses, the

# Locking

When locking funds at the smart contract address, users will provide a datum to satisify the following Haskell type:
```haskell
data Input = Input
  { iRequiredCount :: Integer
  , iKeys          :: [PubKeyHash]
  }
```

The `iRequiredCount` count says how many keys are required to unlock the funds. The `iKeys` list the public key hashes for the users who can potentially sign to unlock the funds.

## ⚠️ Warning

When locking funds, one needs to ensure the datum is properly configured, otherwise the funds could be locked forever. Specifically the following conditions should be met:

1. The `iKeys` list is non-empty.
2. There are no duplicates in the `iKeys` list.
3. The `iRequiredCount` is less than or equal to the lenght of the `iKeys` array.

# Updating

# Closing
