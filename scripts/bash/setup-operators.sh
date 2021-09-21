#!/usr/bin/env bash

set -e

echo "*** Run node operators ***"

echo "Starting Chainlink nodes "
docker-compose up -d postgres-cl chainlink-node-1 chainlink-node-2 chainlink-node-3
echo "Waiting for chainlink nodes to be ready"
sleep 20

echo "Starting Chain adapters"
docker-compose up -d chain-adapter-1 chain-adapter-2 chain-adapter-3

echo "Starting Price adapters "
docker-compose up -d crypto-price-adapter-1 crypto-price-adapter-2 crypto-price-adapter-3 stock-price-adapter-1 stock-price-adapter-2 stock-price-adapter-3

./scripts/bash/add-bridges.sh

source ./scripts/bash/add-ei.sh

add_ei "1"
add_ei "2"
add_ei "3"

docker-compose up -d external-initiator-1 external-initiator-2 external-initiator-3
echo "Waiting for external initiators to be ready"
sleep 20

./scripts/bash/add-jobspecs.sh