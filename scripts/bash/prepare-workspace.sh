#!/usr/bin/env bash

set -e

echo "" > ./external_initiator.env

git submodule update --init --recursive

(cd ./scripts/terrajs && yarn)

(cd ./external-initiator && docker build . -t terrademo/terra-ei)
(cd ./terra-fm-metrics-exporter && docker build . -t terra-chainlink-exporter)

(cd ./external-adapters && yarn && yarn setup && \
    # yarn generate:docker-compose && \
    docker-compose -f docker-compose.generated.yaml build terra-adapter)
