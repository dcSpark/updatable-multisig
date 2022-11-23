#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp
assetDir=$baseDir/../assets

mkdir -p $tempDir
$baseDir/hash-plutus.sh

validatorFile=$assetDir/$BLOCKCHAIN_PREFIX/vesting.plutus
benefactorAddress=$1
signingKey=$2
scriptDatumHash=$3
output=$4
scriptHash=$(cat $assetDir/$BLOCKCHAIN_PREFIX/vesting.addr)

bodyFile=$tempDir/lock-tx-body.01
outFile=$tempDir/lock-tx.01
changeOutput=$(cardano-cli-balance-fixer change --address $benefactorAddress $BLOCKCHAIN -o "$output")

extraOutput=""
if [ "$changeOutput" != "" ];then
  extraOutput="+ $changeOutput"
fi

cardano-cli transaction build \
    --babbage-era \
    $BLOCKCHAIN \
    $(cardano-cli-balance-fixer input --address $benefactorAddress $BLOCKCHAIN) \
    --tx-out "$scriptHash + $output" \
    --tx-out-datum-hash $scriptDatumHash \
    --tx-out "$benefactorAddress + 1744798 lovelace $extraOutput" \
    --change-address $benefactorAddress \
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

echo
