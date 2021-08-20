
#!/bin/bash
source ./scripts/bash/common.sh
echo "Adding JobSpecs to Chainlink node..."

function jobspec() {
echo $(
cat << EOF
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
          "account_address": "$1",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LINK", "to": "USD" }
            },
            "feeds": [{ "url": "http://price-adapter-1:8080" }, { "url": "http://price-adapter-2:8080" },  { "url": "http://price-adapter-3:8080" }],
            "threshold": 0.3,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "5s" },
            "idleTimer": { "duration": "50s" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "$2",
      "params": {}
    }
  ]
}
EOF
)
}

function jobspec2() {
echo $(
cat << EOF
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1z449mpul3pwkdd3892gv28ewv5l06w7895wewm",
          "account_address": "$1",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LUNA", "to": "USD" }
            },
            "feeds": [{ "url": "http://price-adapter-1:8080" }, { "url": "http://price-adapter-2:8080" },  { "url": "http://price-adapter-3:8080" }],
            "threshold": 0.3,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "5s" },
            "idleTimer": { "duration": "50s" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "$2",
      "params": {}
    }
  ]
}
EOF
)
}

CL_URL="http://localhost:6691"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95"
BRIDGE_NAME="terra-adapter1"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID


CL_URL="http://localhost:6692"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp"
BRIDGE_NAME="terra-adapter2"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID


CL_URL="http://localhost:6693"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r"
BRIDGE_NAME="terra-adapter3"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/specs")
echo $JOBID


echo "Jobspecs has been added to Chainlink nodes"

