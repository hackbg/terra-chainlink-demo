#!/bin/bash
source ./scripts/bash/common.sh

echo "Adding Bridges to Chainlink node..."

CL_URL="http://localhost:6691"

login_cl "$CL_URL"

payload1=$(
  cat <<EOF
{
"name": "terra-adapter1",
"url": "http://chain-adapter-1:8080/"
}
EOF
)

curl -s -b ./cookiefile -d "$payload1" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/bridge_types" &>/dev/null

CL_URL="http://localhost:6692"

login_cl "$CL_URL"

payload2=$(
  cat <<EOF
{
"name": "terra-adapter2",
"url": "http://chain-adapter-2:8080/"
}
EOF
)

curl -s -b ./cookiefile -d "$payload2" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/bridge_types" &>/dev/null

CL_URL="http://localhost:6693"

login_cl "$CL_URL"

payload3=$(
  cat <<EOF
{
"name": "terra-adapter3",
"url": "http://chain-adapter-3:8080/"
}
EOF
)

curl -s -b ./cookiefile -d "$payload3" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/bridge_types" &>/dev/null

echo "Bridges has been added to Chainlink nodes"