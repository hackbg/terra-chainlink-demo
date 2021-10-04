
#!/bin/bash
source ./scripts/bash/common.sh
echo "Adding JobSpecs to Chainlink node..."

LINKUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[0]' ./scripts/terrajs/addresses.json))
LUNAUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[1]' ./scripts/terrajs/addresses.json))
BTCUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[2]' ./scripts/terrajs/addresses.json))
ETHUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[3]' ./scripts/terrajs/addresses.json))
AAPLUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[4]' ./scripts/terrajs/addresses.json))
GOOGLUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[5]' ./scripts/terrajs/addresses.json))
FBUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[6]' ./scripts/terrajs/addresses.json))
AMZNUSD_AGGREGATOR=($(jq -r '.contracts | keys_unsorted[7]' ./scripts/terrajs/addresses.json))

echo "LINKUSD_AGGREGATOR"
echo $LINKUSD_AGGREGATOR

echo "LUNAUSD_AGGREGATOR"
echo $LUNAUSD_AGGREGATOR

echo "BTCUSD_AGGREGATOR"
echo $BTCUSD_AGGREGATOR

echo "ETHUSD_AGGREGATOR"
echo $ETHUSD_AGGREGATOR

echo "AAPLUSD_AGGREGATOR"
echo $AAPLUSD_AGGREGATOR

echo "GOOGLUSD_AGGREGATOR"
echo $GOOGLUSD_AGGREGATOR

echo "FBUSD_AGGREGATOR"
echo $FBUSD_AGGREGATOR

echo "AMZNUSD_AGGREGATOR"
echo $AMZNUSD_AGGREGATOR
# TODO: Extreme duplication, handle it
function jobspec() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$LINKUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"LINK\\\\\\", \\\\\\"to\\\\\\": \\\\\\"USD\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://crypto-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}

function jobspec2() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$LUNAUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"LUNA\\\\\\", \\\\\\"to\\\\\\": \\\\\\"USD\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://crypto-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 

requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec3() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$BTCUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"BTC\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://crypto-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec4() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$ETHUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"ETH\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://crypto-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec5() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$AAPLUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"AAPL\\\\\\", \\\\\\"to\\\\\\": \\\\\\"USD\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://stock-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec6() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$GOOGLUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"GOOGL\\\\\\", \\\\\\"to\\\\\\": \\\\\\"USD\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://stock-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec7() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$FBUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"FB\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://stock-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}


function jobspec8() {
echo $(
cat << EOF
{"toml":"
type            = \"webhook\"\n
schemaVersion   = 1\n
externalInitiators = [\n  
{ name = \"terra\", spec = \"{ \\\\\\"type\\\\\\": \\\\\\"external\\\\\\", \\\\\\"endpoint\\\\\\": \\\\\\"terra\\\\\\", 
\\\\\\"contract_address\\\\\\": \\\\\\"$AMZNUSD_AGGREGATOR\\\\\\", 
\\\\\\"account_address\\\\\\": \\\\\\"$1\\\\\\", 
\\\\\\"fluxmonitor\\\\\\": { 
    \\\\\\"requestData\\\\\\": { \\\\\\"data\\\\\\": { \\\\\\"from\\\\\\": \\\\\\"AMZN\\\\\\" } }, 
    \\\\\\"feeds\\\\\\": [{ \\\\\\"url\\\\\\": \\\\\\"http://stock-price-adapter-3:8080\\\\\\" }], 
    \\\\\\"threshold\\\\\\": 0.3, 
    \\\\\\"absoluteThreshold\\\\\\": 0, 
    \\\\\\"precision\\\\\\": 8, 
    \\\\\\"pollTimer\\\\\\": { \\\\\\"period\\\\\\": \\\\\\"30s\\\\\\" }, 
    \\\\\\"idleTimer\\\\\\": { \\\\\\"duration\\\\\\": \\\\\\"50s\\\\\\" } } } \" }\n]\n
observationSource   = \"\"\"\n    
parse_request  [type=jsonparse path=\"\" data=\"\$(jobRun.requestBody)\"]\n    
send_to_bridge [type=bridge timeout=0 name=\"$2\" 
requestData=<{ \"data\": \$(parse_request)}>]\n    
parse_request -> send_to_bridge\n\"\"\""}
EOF
)
}

CL_URL="http://localhost:6691"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95"
BRIDGE_NAME="terra-adapter1"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec3 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec4 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec5 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec6 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec7 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec8 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

CL_URL="http://localhost:6692"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp"
BRIDGE_NAME="terra-adapter2"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec3 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec4 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec5 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec6 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec7 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec8 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

CL_URL="http://localhost:6693"
login_cl "$CL_URL"
ORACLE_ADDRESS="terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r"
BRIDGE_NAME="terra-adapter3"

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec2 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec3 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec4 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec5 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec6 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec7 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

JOBID=$(curl -s -b ./cookiefile -d "$(jobspec8 $ORACLE_ADDRESS $BRIDGE_NAME)" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/jobs")
echo $JOBID

echo "Jobspecs has been added to Chainlink nodes"

