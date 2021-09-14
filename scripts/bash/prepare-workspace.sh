#!/usr/bin/env bash

set -e

echo "" > ./external_initiator1.env
echo "" > ./external_initiator2.env
echo "" > ./external_initiator3.env

git submodule sync --recursive
git submodule update --remote --init --recursive

(cd ./scripts/terrajs && yarn)

(cd ./external-initiator && docker build . -t terrademo/terra-ei)
(cd ./terra-fm-metrics-exporter && docker build . -t terra-chainlink-exporter)

(cd ./external-adapters && yarn && yarn setup && \
    yarn generate:docker-compose && \
    docker-compose -f docker-compose.generated.yaml build terra-adapter)
