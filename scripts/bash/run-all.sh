#!/usr/bin/env bash

set -e

echo "*** Run all ***"

./scripts/bash/setup-feeds.sh

./scripts/bash/setup-operators.sh

./scripts/bash/check-answer.sh

