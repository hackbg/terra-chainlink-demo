#!/bin/bash

source ./scripts/bash/common.sh

echo "Adding JobSpecs to Chainlink node..."

CL_URL="http://localhost:6688"

login_cl "$CL_URL"

payload=$(
cat <<EOF
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
          "account_address": "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LUNA", "to": "USD" }
            },
            "feeds": [{ "url": "http://coingecko-adapter:8080" }],
            "threshold": 0.5,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "30s" },
            "idleTimer": { "duration": "1m" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "terra-adapter1",
      "params": {}
    }
  ]
}
EOF
)

payload2=$(
cat <<EOF
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
          "account_address": "terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LUNA", "to": "USD" }
            },
            "feeds": [{ "url": "http://coingecko-adapter:8080" }],
            "threshold": 0.5,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "30s" },
            "idleTimer": { "duration": "1m" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "terra-adapter2",
      "params": {}
    }
  ]
}
EOF
)

JOBID=$(curl -s -b ./cookiefile -d "$payload" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$payload2" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID
echo "Jobspecs has been added to Chainlink node"
