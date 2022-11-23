set -eux

bodyFile=temp/consolidate-tx-body.01
signingKey=~/$BLOCKCHAIN_PREFIX/benefactor.skey
outFile=temp/consolidate-tx.01
senderAddr=$(cat ~/$BLOCKCHAIN_PREFIX/benefactor.addr)
receiverAddr=$(cat ~/$BLOCKCHAIN_PREFIX/beneficiary.addr)

cardano-cli transaction build \
  --babbage-era \
  $BLOCKCHAIN \
  --tx-in 7f77f4b7074ec8a61cb16e87aaa10fc25fa06daae4c62a9565a1751c640680b5#0 \
  --tx-out "$receiverAddr +50000000 lovelace" \
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
