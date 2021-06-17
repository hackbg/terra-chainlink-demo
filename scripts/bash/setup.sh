#!/usr/bin/env bash

set -e

echo "*** Run components ***"

cd $(dirname ${BASH_SOURCE[0]})/../..
ls
docker-compose down --remove-orphans --volumes

docker-compose up -d coingecko-adapter
echo "Coingecko source adapter started"

./scripts/bash/run-terra.sh
echo "Waiting for terra services to be ready"

./scripts/bash/run-chainlink.sh
echo "Waiting for chainlink services to be ready"
sleep 10
./scripts/bash/run-adapter.sh
echo "Waiting for the external adapter to be ready"

./scripts/bash/add-bridges.sh
echo "Waiting for bridges to be added"

./scripts/bash/ei-config.sh
echo "Configuring ei"

./scripts/bash/run-ei.sh
echo "Starting ei"
