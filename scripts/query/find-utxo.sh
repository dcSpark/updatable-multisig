#!/usr/bin/env bash

N="$(basename "$0")"

cardano-cli query utxo --address $(cat ~/$BLOCKCHAIN_PREFIX/$N.addr) $BLOCKCHAIN
