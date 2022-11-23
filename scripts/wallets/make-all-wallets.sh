#!/usr/bin/env bash

set -eux
mkdir -p scripts/temp/
mkdir -p ~/$BLOCKCHAIN_PREFIX
./scripts/wallets/make-wallet-and-pkh.sh user0
./scripts/wallets/make-wallet-and-pkh.sh user1
./scripts/wallets/make-wallet-and-pkh.sh user2
./scripts/wallets/make-wallet-and-pkh.sh user3
./scripts/wallets/make-wallet-and-pkh.sh user4
