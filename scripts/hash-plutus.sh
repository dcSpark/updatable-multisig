#!/usr/bin/env bash

set -eu

thisDir=$(dirname "$0")
mainDir=$thisDir/..
assetDir=$mainDir/assets
mkdir -p $assetDir/mainnet
mkdir -p $assetDir/testnet
mkdir -p $assetDir/local-testnet

cardano-cli address build \
  --payment-script-file $assetDir/multisig.plutus \
  --mainnet \
  --out-file $assetDir/mainnet/multisig.addr

cardano-cli address build \
  --payment-script-file $assetDir/multisig.plutus \
  --testnet-magic 1097911063 \
  --out-file $assetDir/testnet/multisig.addr

cardano-cli address build \
  --payment-script-file $assetDir/multisig.plutus \
  --testnet-magic 42 \
  --out-file $assetDir/local-testnet/multisig.addr
