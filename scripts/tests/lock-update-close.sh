set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$baseDir/generate-datums.sh

$baseDir/happy-path/lock-tx.sh
$baseDir/wait/until-next-block.sh

echo Bad Required Count
detected=false

"$baseDir/failure-cases/update-bad-required-count-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Unlocked with bad required count"
  exit 1
fi

echo Bad Keys
detected=false

"$baseDir/failure-cases/update-bad-missing-keys-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Updating with an bad keys datum succeeded"
  exit 1
fi

echo Update with wrong signatures
detected=false

"$baseDir/failure-cases/update-wrong-signatures-tx copy.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Updating wrong keys succeeded"
  exit 1
fi

$baseDir/wait/until-next-block.sh
$baseDir/happy-path/update-tx.sh
$baseDir/wait/until-next-block.sh

echo Close with wrong signatures
detected=false

"$baseDir/failure-cases/close-wrong-signatures-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Close with the wrong keys worked"
  exit 1
fi


$baseDir/happy-path/close-tx.sh
