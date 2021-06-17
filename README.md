# Chainlink <> Terra demo

TODO: What this demo is about?

## Clone the repo and initialize submodules

Make sure to clone the submodules as well as they are required for the whole docker setup to run.

```bash
git clone --recurse-submodules https://github.com/hackbg/terra-chainlink-demo
```

## Setup

1. Prepare workspace

```bash
./scripts/bash/prepare-workspace.sh
```

2. Run all services

```bash
./scripts/bash/setup.sh
```

3. Log into node operator console

Go to http://localhost:6688. Credentials: `test@test.two:chainzzz`

4. Initiate job runs to simulate 2 oracles in action

Go to http://localhost:6688/jobs/new and use the following JSONs:

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
      "params": {}
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
      "params": {}
    }
  ]
}
```

---

## Debugging

### `external_initiator.env` not found when running setup script

Create a empty `external_initiator.env` file in the root of the repo

---

### Listening for flux aggregator events

```bash
wscat -c ws://localhost:26657/websocket

> { "jsonrpc": "2.0", "method": "subscribe", "params": ["tm.event='Tx' AND execute_contract.contract_address='terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6'"], "id": 1 }
```

Example response:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "query": "tm.event='Tx' AND execute_contract.contract_address='terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6'",
    "data": {
      "type": "tendermint/event/Tx",
      "value": {
        "TxResult": {
          "height": "105",
          "tx": "CrcBCrQBCiYvdGVycmEud2FzbS52MWJldGExLk1zZ0V4ZWN1dGVDb250cmFjdBKJAQosdGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTUSLHRlcnJhMXRuZGNhcXhrcGM1Y2U5cWVlNWdncWY0MzBtcjJ6M3BlZmU1d2o2Git7InN1Ym1pdCI6eyJyb3VuZF9pZCI6MSwic3VibWlzc2lvbiI6IjEzIn19EmwKTgpGCh8vY29zbW9zLmNyeXB0by5zZWNwMjU2azEuUHViS2V5EiMKIQIwbotg05C1SqNqebgl3+vEmx80g6EQxEijbbK9/r7SSBIECgIIfxIaChQKBXVsdW5hEgsyNDE3MjkwMDAwMBDB4A4aQD/q1iiJIDitm+Af6VYcSawPZrDGL8hBcHA6B/85nGGQATysrQuW0SzrAzJisPd6QhaPojyWT3nEzmGxGHUzHvY=",
          "result": {
            "data": "CigKJi90ZXJyYS53YXNtLnYxYmV0YTEuTXNnRXhlY3V0ZUNvbnRyYWN0",
            "log": "[{\"events\":[{\"type\":\"execute_contract\",\"attributes\":[{\"key\":\"sender\",\"value\":\"terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95\"},{\"key\":\"contract_address\",\"value\":\"terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6\"},{\"key\":\"sender\",\"value\":\"terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6\"},{\"key\":\"contract_address\",\"value\":\"terra10pyejy66429refv3g35g2t7am0was7ya7kz2a4\"}]},{\"type\":\"from_contract\",\"attributes\":[{\"key\":\"contract_address\",\"value\":\"terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6\"},{\"key\":\"action\",\"value\":\"answer_updated\"},{\"key\":\"current\",\"value\":\"13\"},{\"key\":\"round_id\",\"value\":\"1\"},{\"key\":\"contract_address\",\"value\":\"terra10pyejy66429refv3g35g2t7am0was7ya7kz2a4\"},{\"key\":\"action\",\"value\":\"validate\"},{\"key\":\"is valid\",\"value\":\"true\"}]},{\"type\":\"message\",\"attributes\":[{\"key\":\"action\",\"value\":\"/terra.wasm.v1beta1.MsgExecuteContract\"},{\"key\":\"module\",\"value\":\"wasm\"},{\"key\":\"sender\",\"value\":\"terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95\"},{\"key\":\"module\",\"value\":\"wasm\"},{\"key\":\"sender\",\"value\":\"terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6\"}]}]}]",
            "gas_wanted": "241729",
            "gas_used": "186334",
            "events": [
              {
                "type": "coin_spent",
                "attributes": [
                  {
                    "key": "c3BlbmRlcg==",
                    "value": "dGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTU=",
                    "index": true
                  },
                  {
                    "key": "YW1vdW50",
                    "value": "MjQxNzI5MDAwMDB1bHVuYQ==",
                    "index": true
                  }
                ]
              },
              {
                "type": "coin_received",
                "attributes": [
                  {
                    "key": "cmVjZWl2ZXI=",
                    "value": "dGVycmExN3hwZnZha20yYW1nOTYyeWxzNmY4NHoza2VsbDhjNWxrYWVxZmE=",
                    "index": true
                  },
                  {
                    "key": "YW1vdW50",
                    "value": "MjQxNzI5MDAwMDB1bHVuYQ==",
                    "index": true
                  }
                ]
              },
              {
                "type": "transfer",
                "attributes": [
                  {
                    "key": "cmVjaXBpZW50",
                    "value": "dGVycmExN3hwZnZha20yYW1nOTYyeWxzNmY4NHoza2VsbDhjNWxrYWVxZmE=",
                    "index": true
                  },
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTU=",
                    "index": true
                  },
                  {
                    "key": "YW1vdW50",
                    "value": "MjQxNzI5MDAwMDB1bHVuYQ==",
                    "index": true
                  }
                ]
              },
              {
                "type": "message",
                "attributes": [
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTU=",
                    "index": true
                  }
                ]
              },
              {
                "type": "message",
                "attributes": [
                  {
                    "key": "YWN0aW9u",
                    "value": "L3RlcnJhLndhc20udjFiZXRhMS5Nc2dFeGVjdXRlQ29udHJhY3Q=",
                    "index": true
                  }
                ]
              },
              {
                "type": "execute_contract",
                "attributes": [
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTU=",
                    "index": true
                  },
                  {
                    "key": "Y29udHJhY3RfYWRkcmVzcw==",
                    "value": "dGVycmExdG5kY2FxeGtwYzVjZTlxZWU1Z2dxZjQzMG1yMnozcGVmZTV3ajY=",
                    "index": true
                  }
                ]
              },
              {
                "type": "message",
                "attributes": [
                  {
                    "key": "bW9kdWxl",
                    "value": "d2FzbQ==",
                    "index": true
                  },
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExNzU3dGt4MDhuMGNxcnc3cDg2bnk5bG54c3FldGgwd2dwMGVtOTU=",
                    "index": true
                  }
                ]
              },
              {
                "type": "from_contract",
                "attributes": [
                  {
                    "key": "Y29udHJhY3RfYWRkcmVzcw==",
                    "value": "dGVycmExdG5kY2FxeGtwYzVjZTlxZWU1Z2dxZjQzMG1yMnozcGVmZTV3ajY=",
                    "index": true
                  },
                  {
                    "key": "YWN0aW9u",
                    "value": "YW5zd2VyX3VwZGF0ZWQ=",
                    "index": true
                  },
                  {
                    "key": "Y3VycmVudA==",
                    "value": "MTM=",
                    "index": true
                  },
                  {
                    "key": "cm91bmRfaWQ=",
                    "value": "MQ==",
                    "index": true
                  }
                ]
              },
              {
                "type": "execute_contract",
                "attributes": [
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExdG5kY2FxeGtwYzVjZTlxZWU1Z2dxZjQzMG1yMnozcGVmZTV3ajY=",
                    "index": true
                  },
                  {
                    "key": "Y29udHJhY3RfYWRkcmVzcw==",
                    "value": "dGVycmExMHB5ZWp5NjY0MjlyZWZ2M2czNWcydDdhbTB3YXM3eWE3a3oyYTQ=",
                    "index": true
                  }
                ]
              },
              {
                "type": "message",
                "attributes": [
                  {
                    "key": "bW9kdWxl",
                    "value": "d2FzbQ==",
                    "index": true
                  },
                  {
                    "key": "c2VuZGVy",
                    "value": "dGVycmExdG5kY2FxeGtwYzVjZTlxZWU1Z2dxZjQzMG1yMnozcGVmZTV3ajY=",
                    "index": true
                  }
                ]
              },
              {
                "type": "from_contract",
                "attributes": [
                  {
                    "key": "Y29udHJhY3RfYWRkcmVzcw==",
                    "value": "dGVycmExMHB5ZWp5NjY0MjlyZWZ2M2czNWcydDdhbTB3YXM3eWE3a3oyYTQ=",
                    "index": true
                  },
                  {
                    "key": "YWN0aW9u",
                    "value": "dmFsaWRhdGU=",
                    "index": true
                  },
                  {
                    "key": "aXMgdmFsaWQ=",
                    "value": "dHJ1ZQ==",
                    "index": true
                  }
                ]
              }
            ]
          }
        }
      }
    },
    "events": {
      "from_contract.round_id": ["1"],
      "from_contract.is valid": ["true"],
      "transfer.recipient": ["terra17xpfvakm2amg962yls6f84z3kell8c5lkaeqfa"],
      "message.sender": [
        "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
        "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
        "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6"
      ],
      "message.action": ["/terra.wasm.v1beta1.MsgExecuteContract"],
      "message.module": ["wasm", "wasm"],
      "transfer.amount": ["24172900000uluna"],
      "from_contract.contract_address": [
        "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
        "terra10pyejy66429refv3g35g2t7am0was7ya7kz2a4"
      ],
      "tm.event": ["Tx"],
      "tx.height": ["105"],
      "transfer.sender": ["terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95"],
      "execute_contract.contract_address": [
        "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6",
        "terra10pyejy66429refv3g35g2t7am0was7ya7kz2a4"
      ],
      "tx.hash": [
        "F86DDF2F2569FD0E0BC17F5883006A7DE3C538B4586267E402441EAF80807A70"
      ],
      "execute_contract.sender": [
        "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
        "terra1tndcaqxkpc5ce9qee5ggqf430mr2z3pefe5wj6"
      ],
      "from_contract.action": ["answer_updated", "validate"],
      "from_contract.current": ["13"],
      "coin_spent.spender": ["terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95"],
      "coin_spent.amount": ["24172900000uluna"],
      "coin_received.receiver": [
        "terra17xpfvakm2amg962yls6f84z3kell8c5lkaeqfa"
      ],
      "coin_received.amount": ["24172900000uluna"]
    }
  }
}
```

`"from_contract"` - custom attributes emitted from the contract (base64 encoded)
