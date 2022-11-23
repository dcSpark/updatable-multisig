#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

$baseDir/core/unlock-first-successfully-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/beneficiary.addr) \
  ~/$BLOCKCHAIN_PREFIX/beneficiary.skey \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/multisig.json \
  $(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/vesting-hash.txt) \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/invalid.json \
  600000 \
  1400000 \
  $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX/disburse.json
