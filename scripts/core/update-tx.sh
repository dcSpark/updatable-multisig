#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/..
assetDir=$baseDir/../assets

signingAddr=$1
signingKey0=$2
signingKey1=$3
signingKey2=$4
oldDatumFile=$5
oldDatumHash=$6
newDatum=$7
unlockAmount=$8
leftOverAmount=$9
redeemerFile=$baseDir/redeemers/update.json

validatorFile=$assetDir/multisig.plutus
scriptHash=$(cat $assetDir/$BLOCKCHAIN_PREFIX/multisig.addr)

bodyFile=temp/unlock-tx-body.01
outFile=temp/unlock-tx.01

utxoScript=$($baseDir/query/sc | grep $oldDatumHash | cardano-cli-balance-fixer parse-as-utxo)
output1="1724100 lovelace + $unlockAmount"
currentSlot=$(cardano-cli query tip $BLOCKCHAIN | jq .slot)
startSlot=$currentSlot
nextTenSlots=$(($currentSlot+150))

changeOutput=$(cardano-cli-balance-fixer change --address $signingAddr $BLOCKCHAIN)
extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi

cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $signingAddr $BLOCKCHAIN ) \
    --tx-in $utxoScript \
    --tx-in-script-file $validatorFile \
    --tx-in-datum-file $oldDatumFile \
    --tx-in-redeemer-file $redeemerFile \
    --required-signer $signingKey0 \
    --required-signer $signingKey1 \
    --required-signer $signingKey2 \
    --tx-in-collateral $(cardano-cli-balance-fixer collateral --address $signingAddr $BLOCKCHAIN) \
    --tx-out "$scriptHash + $leftOverAmount" \
    --tx-out-datum-embed-file $newDatum \
    --tx-out "$signingAddr + $output1" \
    --change-address $signingAddr \
    --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --invalid-before $startSlot\
    --invalid-hereafter $nextTenSlots \
    --out-file $bodyFile


echo "saved transaction to $bodyFile"

cardano-cli transaction sign \
   --tx-body-file $bodyFile \
   --signing-key-file $signingKey0 \
   --signing-key-file $signingKey1 \
   --signing-key-file $signingKey2 \
   $BLOCKCHAIN \
   --out-file $outFile

echo "signed transaction and saved as $outFile"

cardano-cli transaction submit \
  $BLOCKCHAIN \
  --tx-file $outFile

echo "submitted transaction"

echo
