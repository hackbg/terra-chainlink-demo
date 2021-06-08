#!/usr/bin/env bash

set -e

echo "*** Run terra ***"

cd $(dirname ${BASH_SOURCE[0]})/../..

docker-compose up -d postgres terrad oracle fcd-collector fcd-api