#!/bin/bash

login_cl() {
  CL_URL=$1

  username=""
  password=""

  while IFS= read -r line; do
    if [[ "$username" == "" ]]; then
      username=${line}
    else
      password=${line}
    fi
  done <"./secrets/apicredentials"

  echo "" >./cookiefile

  curl -s -c ./cookiefile -d "{\"email\":\"${username}\", \"password\":\"${password}\"}" -X POST -H 'Content-Type: application/json' "$CL_URL/sessions" &>/dev/null
}

echo "Adding Bridges to Chainlink node..."

CL_URL="http://localhost:6688"

login_cl "$CL_URL"

payload=$(
  cat <<EOF
{
"name": "terra-adapter",
"url": "http://external-adapter:8080/"
}
EOF
)

curl -s -b ./cookiefile -d "$payload" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/bridge_types" &>/dev/null

echo "Bridges has been added to Chainlink node"