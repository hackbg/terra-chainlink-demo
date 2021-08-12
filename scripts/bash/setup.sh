#!/usr/bin/env bash

set -e

echo "*** Run all ***"

docker-compose down --remove-orphans --volumes

./scripts/bash/setup-feeds.sh

./scripts/bash/setup-operators.sh

echo "Waiting a bit for the answer to be written on-chain"
sleep 60

docker-compose up -d prometheus
docker-compose up -d terra-chainlink-exporter

./scripts/bash/check-answer.sh

