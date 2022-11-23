set -eux

bodyFile=temp/consolidate-tx-body.01
signingKey=/Users/jonathanfischoff/prototypes/cardano-node/example/stake-delegator-keys/payment1.skey
senderAddr=$(cardano-cli address build --testnet-magic "42" --payment-verification-key-file /Users/jonathanfischoff/prototypes/cardano-node/example/stake-delegator-keys/payment1.vkey --stake-verification-key-file /Users/jonathanfischoff/prototypes/cardano-node/example/stake-delegator-keys/staking1.vkey)
outFile=temp/consolidate-tx.01
benefactorAddr=$(cat ~/$BLOCKCHAIN_PREFIX/benefactor.addr)
beneficiaryAddr=$(cat ~/$BLOCKCHAIN_PREFIX/beneficiary.addr)
beneficiary1Addr=$(cat ~/$BLOCKCHAIN_PREFIX/beneficiary1.addr)
beneficiary2Addr=$(cat ~/$BLOCKCHAIN_PREFIX/beneficiary2.addr)
beneficiary3Addr=$(cat ~/$BLOCKCHAIN_PREFIX/beneficiary3.addr)

cardano-cli transaction build \
  --babbage-era \
  $BLOCKCHAIN \
  $(cardano-cli-balance-fixer input --address $senderAddr $BLOCKCHAIN ) \
  --tx-out "$benefactorAddr + 45000000000 lovelace" \
  --tx-out "$beneficiaryAddr + 45000000000 lovelace" \
  --tx-out "$beneficiary1Addr + 4500000000 lovelace" \
  --tx-out "$beneficiary2Addr + 4500000000 lovelace" \
  --tx-out "$beneficiary3Addr + 4500000000 lovelace" \
  --change-address $senderAddr \
  --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
  --out-file $bodyFile

echo "saved transaction to $bodyFile"

cardano-cli transaction sign \
   --tx-body-file $bodyFile \
   --signing-key-file $signingKey \
   $BLOCKCHAIN \
   --out-file $outFile

echo "signed transaction and saved as $outFile"

cardano-cli transaction submit \
 $BLOCKCHAIN \
 --tx-file $outFile

echo "submitted transaction"
