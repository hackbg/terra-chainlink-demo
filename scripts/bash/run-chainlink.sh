#!/usr/bin/env bash

set -e

echo "*** Run Chainlink ***"
cd $(dirname ${BASH_SOURCE[0]})/../..

docker-compose up -d chainlink