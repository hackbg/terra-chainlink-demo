#!/usr/bin/env bash

set -e

echo "*** Check answer ***"

echo "Checking onchain answer"
(cd ./scripts/terrajs && yarn checkAnswer)
