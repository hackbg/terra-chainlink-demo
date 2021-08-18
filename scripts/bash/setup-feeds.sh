#!/usr/bin/env bash

set -e

echo "*** Setup feeds ***"

cd $(dirname ${BASH_SOURCE[0]})/../..

rm -rf ./scripts/terrajs/addresses.json
echo "{}" > ./scripts/terrajs/addresses.json
echo "Uploading Chainlink contracts"
# (cd ./scripts/terrajs && yarn start)
./gauntlet-terra-linux deploy --network=localterra --rdd=./scripts/terrajs/addresses.json
./gauntlet-terra-linux instantiateFeed --network=localterra --paymentAmount=100 --minSubmissionValue=100000000 --maxSubmissionValue=10000000000 --timeout=100 --decimals=8 --description=LINK/USD --rdd=./scripts/terrajs/addresses.json
./gauntlet-terra-linux instantiateFeed --network=localterra --paymentAmount=100 --minSubmissionValue=100000000 --maxSubmissionValue=10000000000 --timeout=100 --decimals=8 --description=LUNA/USD --rdd=./scripts/terrajs/addresses.json
