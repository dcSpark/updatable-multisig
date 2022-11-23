#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/../
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

$baseDir/core/unlock-first-successfully-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/beneficiary.addr) \
  ~/$BLOCKCHAIN_PREFIX/beneficiary.skey \
  ~/$BLOCKCHAIN_PREFIX/beneficiary1.skey \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/multisig.json \
  $(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/vesting-hash.txt) \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/vesting-updated-keys.json \
  "600000 lovelace" \
  "1400000 lovelace" \
  $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX/disburse.json
