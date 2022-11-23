set -eu
thisDir=$(dirname "$0")
mainDir=$thisDir/..
tempDir=$mainDir/temp

(
cd $mainDir
cabal run multisig-sc -- --output-file=assets/multisig.plutus
)

$thisDir/hash-plutus.sh
