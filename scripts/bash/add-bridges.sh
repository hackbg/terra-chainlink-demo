#!/bin/bash
source ./scripts/bash/common.sh

echo "Adding Bridges to Chainlink node..."

CL_URL="http://localhost:6691"

login_cl "$CL_URL"

payload1=$(
  cat <<EOF
{
"name": "terra-adapter1",
"url": "http://172.17.0.1:8091/"
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
"url": "http://172.17.0.1:8092/"
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
"url": "http://172.17.0.1:8093/"
}
EOF
)

curl -s -b ./cookiefile -d "$payload3" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/bridge_types" &>/dev/null

echo "Bridges has been added to Chainlink nodes"