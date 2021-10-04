#!/usr/bin/env bash

set -e

echo "*** Run all ***"

docker-compose down --remove-orphans --volumes

rm -rf ./scripts/terrajs/addresses.json
echo "{}" > ./scripts/terrajs/addresses.json
# skip if bombay deployment
./scripts/bash/run-terra.sh
echo "Waiting for localterra services to be ready"
sleep 6

docker-compose up -d pseudo-config

./scripts/bash/setup-feeds.sh $1

./scripts/bash/setup-operators.sh


docker-compose up -d zookeeper
docker-compose up -d kafka

sleep 10
docker-compose exec kafka kafka-topics --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic Terra

docker-compose up -d prometheus
docker-compose up -d terra-chainlink-exporter

echo "Waiting a bit for the answer to be written on-chain"
sleep 30

./scripts/bash/check-answer.sh