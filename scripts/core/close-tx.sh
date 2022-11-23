#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/..
assetDir=$baseDir/../assets

beneficiaryAddr=$1
signingKey=$2
signingKey1=$3
datumFile=$4
datumHash=$5
unlockAmount=$6
redeemerFile=$7

validatorFile=$assetDir/$BLOCKCHAIN_PREFIX/vesting.plutus
scriptHash=$(cat $assetDir/$BLOCKCHAIN_PREFIX/vesting.addr)

$baseDir/hash-plutus.sh
bodyFile=temp/unlock-tx-body.01
outFile=temp/unlock-tx.01
utxoScript=$($baseDir/query/sc | grep $datumHash | cardano-cli-balance-fixer parse-as-utxo)
output1="1724100 lovelace + $unlockAmount"
currentSlot=$(cardano-cli query tip $BLOCKCHAIN | jq .slot)
startSlot=$currentSlot
nextTenSlots=$(($currentSlot+150))

changeOutput=$(cardano-cli-balance-fixer change --address $beneficiaryAddr $BLOCKCHAIN)
extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi


cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $beneficiaryAddr $BLOCKCHAIN ) \
    --tx-in $utxoScript \
    --tx-in-script-file $validatorFile \
    --tx-in-datum-file $datumFile \
    --tx-in-redeemer-file $redeemerFile \
    --required-signer $signingKey \
    --required-signer $signingKey1 \
    --tx-in-collateral $(cardano-cli-balance-fixer collateral --address $beneficiaryAddr $BLOCKCHAIN) \
    --tx-out "$beneficiaryAddr + $output1" \
    --change-address $beneficiaryAddr \
    --protocol-params-file scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json \
    --invalid-before $startSlot\
    --invalid-hereafter $nextTenSlots \
    --out-file $bodyFile

echo "saved transaction to $bodyFile"

cardano-cli transaction sign \
   --tx-body-file $bodyFile \
   --signing-key-file $signingKey \
   --signing-key-file $signingKey1 \
   $BLOCKCHAIN \
   --out-file $outFile

echo "signed transaction and saved as $outFile"

cardano-cli transaction submit \
  $BLOCKCHAIN \
  --tx-file $outFile

echo "submitted transaction"

echo
