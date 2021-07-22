#!/usr/bin/env bash

set -e

echo "*** Run Chainlink nodes ***"
cd $(dirname ${BASH_SOURCE[0]})/../..

docker-compose up -d chainlink-node-1 chainlink-node-2 chainlink-node-3