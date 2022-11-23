set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

mkdir -p $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX

user1=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary1-pkh.txt)
user2=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary2-pkh.txt)
user3=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary3-pkh.txt)
user4=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/beneficiary3-pkh.txt)

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX/update.json
{
  "constructor": 0,
  "fields": [
    {
      "int" : 3
    }
    {
      "list": [
        {
          "bytes": "$user1"
        },
        {
          "bytes": "$user2"
        },
        {
          "bytes": "$user3"
        },
        {
          "bytes": "$user4"
        }
      ]
    }
  ]
}

EOF


cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/redeemers/$DATUM_PREFIX/close.json
{
  "constructor": 1,
  "fields": [
  ]
}

EOF
