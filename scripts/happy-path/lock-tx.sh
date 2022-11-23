#!/usr/bin/env bash

set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/..
tempDir=$baseDir/../temp

NS="$1"
shift

DATUM_DIR="$tempDir/$BLOCKCHAIN_PREFIX/datums/$NS"
DATUM_FILE="$DATUM_DIR/vesting.json"
DATUM_FILE1="$DATUM_DIR/vesting-updated-keys.json"
DATUM_HASH_FILE="${DATUM_FILE%.*}-hash.txt"
INVALID_DATUM_FILE="$DATUM_DIR/invalid.json"

mkdir -p "$DATUM_DIR"

ARGS="--beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary-pkh.txt)"
ARGS="$ARGS --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary1-pkh.txt)"
ARGS="$ARGS --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary2-pkh.txt)"

ARGS1="--beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary1-pkh.txt)"
ARGS1="$ARGS1 --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary2-pkh.txt)"
ARGS1="$ARGS1 --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary3-pkh.txt)"

nowSeconds="$(date +%s)"
lovelaces=0

for i in "$@"; do
  timestamp=$(($nowSeconds+$i))
  ARGS="$ARGS --portion $timestamp:1000000"
  ARGS1="$ARGS1 --portion $timestamp:1000000"
  lovelaces="$(($lovelaces + 1000000))"
done

echo $ARGS
echo $ARGS1

cabal run vesting-sc -- datum --output "$DATUM_FILE"  $ARGS

cabal run vesting-sc -- datum --output "$DATUM_FILE1"  $ARGS1

cabal run vesting-sc -- datum --output "$INVALID_DATUM_FILE" \
  --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary1-pkh.txt) \
  --beneficiaries $(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary2-pkh.txt) \
  --portion $nowSeconds:1000000

$baseDir/hash-plutus.sh

find $tempDir/$BLOCKCHAIN_PREFIX/datums -name "*.json" \
  -exec sh -c 'cardano-cli transaction hash-script-data --script-data-file "$1" > "${1%.*}-hash.txt"' sh {} \;


$baseDir/core/lock-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/benefactor.addr) \
  ~/$BLOCKCHAIN_PREFIX/benefactor.skey \
  $(cat $DATUM_HASH_FILE) \
  "$lovelaces lovelace"
