#!/usr/bin/env bash

set -e

echo "*** Run all ***"

# docker-compose down --remove-orphans --volumes

# # skip if bombay deployment
# rm -rf ./scripts/terrajs/addresses.json
# echo "{}" > ./scripts/terrajs/addresses.json
# ./scripts/bash/run-terra.sh
# echo "Waiting for localterra services to be ready"
# sleep 6

# ./scripts/bash/setup-feeds.sh $1

./scripts/bash/setup-operators.sh

# echo "Waiting a bit for the answer to be written on-chain"
# sleep 60

# ./scripts/bash/check-answer.sh

