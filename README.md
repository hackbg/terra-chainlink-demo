# Chainlink <> Terra demo

TODO: What this demo is about?

## Clone the repo and initialize submodules

Make sure to clone the submodules as well as they are required for the whole docker setup to run.

```bash
git clone --recurse-submodules https://github.com/hackbg/terra-chainlink-demo
```

## Setup
1. Run all services
```bash
./scripts/bash/setup.sh
```

## Job Runs

```json
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
          "account_address": "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LUNA", "to": "USD" }
            },
            "feeds": [{ "url": "http://coingecko-adapter:8080" }],
            "threshold": 0.5,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "30s" },
            "idleTimer": { "duration": "1m" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "terra-adapter1",
      "params": { }
    }
  ]
}
```
```json
{
  "initiators": [
    {
      "type": "external",
      "params": {
        "name": "terra",
        "body": {
          "endpoint": "terra",
          "contract_address": "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
          "account_address": "terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp",
          "fluxmonitor": {
            "requestData": {
              "data": { "from": "LUNA", "to": "USD" }
            },
            "feeds": [{ "url": "http://coingecko-adapter:8080" }],
            "threshold": 0.5,
            "absoluteThreshold": 0,
            "precision": 8,
            "pollTimer": { "period": "30s" },
            "idleTimer": { "duration": "1m" }
          }
        }
      }
    }
  ],
  "tasks": [
    {
      "type": "terra-adapter2",
      "params": { }
    }
  ]
}
```