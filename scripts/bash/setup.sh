#!/usr/bin/env bash

set -e

echo "*** Run components ***"

cd $(dirname ${BASH_SOURCE[0]})/../..
ls
docker-compose down --remove-orphans --volumes

echo "Starting Coingecko source adapter"
docker-compose up -d coingecko-adapter

./scripts/bash/run-terra.sh
echo "Waiting for localterra services to be ready"
sleep 6

echo "Uploading Chainlink contracts"
(cd ./scripts/terrajs && yarn start)

docker-compose up -d prometheus
docker-compose up -d terra-chainlink-exporter

./scripts/bash/run-chainlink.sh
echo "Waiting for chainlink services to be ready"
sleep 10

./scripts/bash/run-adapters.sh

./scripts/bash/add-bridges.sh

./scripts/bash/ei-config.sh

./scripts/bash/run-ei.sh
echo "Waiting for external initiator to be ready"
sleep 10

./scripts/bash/add-jobspecs.sh

echo "Retrieving current price"
(cd ./scripts/terrajs/src && yarn checkAnswer)