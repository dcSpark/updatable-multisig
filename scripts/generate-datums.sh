set -eu
thisDir=$(dirname "$0")
tempDir=$thisDir/../temp

DATUM_PREFIX=${DATUM_PREFIX:-0}

mkdir -p $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX

user0=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/user0-pkh.txt)
user1=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/user1-pkh.txt)
user2=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/user2-pkh.txt)
user3=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/user3-pkh.txt)
user4=$(cat $tempDir/$BLOCKCHAIN_PREFIX/pkhs/user4-pkh.txt)

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/initial.json
{
  "constructor": 0,
  "fields": [
    {
      "int" : 2
    },
    {
      "list": [
        {
          "bytes": "$user0"
        },
        {
          "bytes": "$user1"
        },
        {
          "bytes": "$user2"
        }
      ]
    }
  ]
}

EOF

cat << EOF > $tempDir/$BLOCKCHAIN_PREFIX/datums/$DATUM_PREFIX/updated.json
{
  "constructor": 0,
  "fields": [
    {
      "int" : 3
    },
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

$thisDir/hash-datums.sh
