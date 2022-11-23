#!/usr/bin/env bash
set -eu
cardano-cli query protocol-parameters \
    $BLOCKCHAIN \
    --out-file "scripts/$BLOCKCHAIN_PREFIX/protocol-parameters.json"
