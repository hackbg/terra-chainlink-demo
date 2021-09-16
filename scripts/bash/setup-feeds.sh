#!/usr/bin/env bash

set -e

echo "*** Setup feeds ***"

cd $(dirname ${BASH_SOURCE[0]})/../..
NETWORK=$1
# NETWORK=${NETWORK:="localterra"}

echo "Uploading Chainlink contracts"
# non-gauntlet way of initializing feeds
# (cd ./scripts/terrajs && yarn start)
# fix duplication below?
# the binary is created by running `yarn bundle` https://github.com/smartcontractkit/gauntlet-terra. on `bin` folder
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./gauntlet-terra-linux deploy --network=$NETWORK --rdd=./scripts/terrajs/addresses.json
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LINK/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LUNA/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LINK/ETH --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=BTC/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ./gauntlet-terra-macos deploy --network=$NETWORK --rdd=./scripts/terrajs/addresses.json
    ./gauntlet-terra-macos setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LINK/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-macos setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LUNA/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=LINK/ETH --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
    ./gauntlet-terra-linux setupFeed --network=$NETWORK --paymentAmount=1 --minSubmissionValue=0 --maxSubmissionValue=99999999999999999999999999999 --minSubmissionCount=1 --timeout=60 --decimals=8 --description=BTC/USD --rdd=./scripts/terrajs/addresses.json terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95 terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r
else
    echo "OS not supported"
fi
