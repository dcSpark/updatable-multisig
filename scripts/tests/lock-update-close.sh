set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$baseDir/generate-datums.sh

$baseDir/happy-path/lock-tx.sh
$baseDir/wait/until-next-block.sh

echo Wrong Signatures
detected=false

"$baseDir/happy-path/update-wrong-signatures-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Unlocked with the wrong signatures"
  exit 1
fi

echo Bad Next Input Fails
detected=false

"$baseDir/failure-cases/unlock-first-bad-datum-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Updating with an invalid datum succeeded"
  exit 1
fi

$baseDir/wait/until-next-block.sh
$baseDir/happy-path/update-tx.sh

$baseDir/wait/until-next-block.sh
$baseDir/happy-path/close-tx.sh
