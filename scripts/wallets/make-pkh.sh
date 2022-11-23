set -eux
thisDir=$(dirname "$0")
tempDir=$thisDir/../../temp

mkdir -p $tempDir/$BLOCKCHAIN_PREFIX/pkhs

cardano-cli address key-hash --payment-verification-key-file ~/$BLOCKCHAIN_PREFIX/$1.vkey \
 > $tempDir/$BLOCKCHAIN_PREFIX/pkhs/$1-pkh.txt
