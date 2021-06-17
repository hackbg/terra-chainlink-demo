#!/usr/bin/env bash

set -e

echo "*** Build Adapter ***"
cd $(dirname ${BASH_SOURCE[0]})/../..
cd ./external-adapters
#docker build -t terrademo/terra-external-adapter --build-arg adapter=terra .
cd ..
docker-compose up -d external-adapter1
docker-compose up -d external-adapter2