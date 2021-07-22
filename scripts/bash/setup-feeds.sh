#!/usr/bin/env bash

set -e

echo "*** Setup feeds ***"

cd $(dirname ${BASH_SOURCE[0]})/../..
ls
docker-compose down --remove-orphans --volumes

./scripts/bash/run-terra.sh
echo "Waiting for localterra services to be ready"
sleep 6

echo "Uploading Chainlink contracts"
(cd ./scripts/terrajs && yarn start)
