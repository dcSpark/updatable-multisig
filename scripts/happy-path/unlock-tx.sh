#!/usr/bin/env bash

set -eux

thisDir=$(dirname "$0")
baseDir=$thisDir/..
tempDir=$baseDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

$baseDir/core/unlock-successfully-tx.sh \
  $(cat ~/$BLOCKCHAIN_PREFIX/beneficiary1.addr) \
  ~/$BLOCKCHAIN_PREFIX/beneficiary1.skey \
  ~/$BLOCKCHAIN_PREFIX/beneficiary2.skey \
  $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/vesting-updated-keys.json \
  $(cat $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/vesting-updated-keys-hash.txt) \
  1000000 \
  $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX/disburse.json
