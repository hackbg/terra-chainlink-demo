#!/usr/bin/env bash

set -e

echo "*** Run node operators ***"

echo "Starting Chainlink nodes "
docker-compose up -d postgres chainlink-node-1 chainlink-node-2 chainlink-node-3
echo "Waiting for chainlink nodes to be ready"
sleep 20

echo "Starting Chain adapters"
docker-compose up -d chain-adapter-1 chain-adapter-2 chain-adapter-3

echo "Starting Price adapters "
docker-compose up -d price-adapter-1 price-adapter-2 price-adapter-3

./scripts/bash/add-bridges.sh

source ./scripts/bash/add-ei.sh

add_ei "1"
add_ei "2"
add_ei "3"

docker-compose up -d external-initiator-1 external-initiator-2 external-initiator-3
echo "Waiting for external initiators to be ready"
sleep 10
LINKUSD_AGGREGATOR=($(jq -r .FLUX_AGGREGATOR ./scripts/terrajs/addresses-LINKUSD.json))
LUNAUSD_AGGREGATOR=($(jq -r .FLUX_AGGREGATOR ./scripts/terrajs/addresses-LUNAUSD.json))

./scripts/bash/add-jobspecs.sh $LINKUSD_AGGREGATOR $LUNAUSD_AGGREGATOR

