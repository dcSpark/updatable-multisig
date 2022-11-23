set -eu

thisDir=$(dirname "$0")
baseDir=$thisDir/../

$baseDir/generate-redeemers.sh

$baseDir/happy-path/lock-tx.sh 0 10 20
$baseDir/wait/until-next-block.sh

echo Early Disburse Fails
detected=false

"$baseDir/happy-path/unlock-first-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Disbursed funds too early"
  exit 1
fi

echo Bad Datum Fails
detected=false

"$baseDir/failure-cases/unlock-first-bad-datum-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Updating with an invalid datum succeeded"
  exit 1
fi

echo Too Few Signers Fails
detected=false
"$baseDir/failure-cases/unlock-first-to-few-signers-tx.sh" || {
    detected=true
}

if [ $detected == false ]; then
  echo "FAILED! Signing with too few keys worked."
  exit 1
fi

sleep 10
$baseDir/wait/until-next-block.sh
$baseDir/happy-path/unlock-first-tx.sh

sleep 20
$baseDir/wait/until-next-block.sh
$baseDir/happy-path/unlock-tx.sh
