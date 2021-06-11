import { readFileSync } from "fs";
import {
  LCDClient,
  MnemonicKey,
  MsgExecuteContract,
  MsgInstantiateContract,
  MsgStoreCode,
} from "@terra-money/terra.js";

const LINK_PATH =
  "../../terra-contracts/contracts/artifacts/link_token.wasm";
const FLUX_PATH =
  "../../terra-contracts/contracts/artifacts/flux_aggregator.wasm";
const FLAGS_PATH =
  "../../terra-contracts/contracts/artifacts/flags.wasm";
const DEVIATION_FLAGGING_VALIDATOR_PATH =
  "../../terra-contracts/contracts/artifacts/deviation_flagging_validator.wasm";

const mk = new MnemonicKey({
  mnemonic:
    "quality vacuum heart guard buzz spike sight swarm shove special gym robust assume sudden deposit grid alcohol choice devote leader tilt noodle tide penalty",
});

const terra = new LCDClient({
  URL: "http://localhost:1317",
  chainID: "localterra",
  gasPrices: { uluna: 1000000 },
});

const wallet = terra.wallet(mk);

run();

async function run() {
  const linkAddr = await uploadAndInstantiate(LINK_PATH, {});
  const fluxAddr = await uploadAndInstantiate(FLUX_PATH, {
    link: "terra18vd8fpwxzck93qlwghaj6arh4p7c5n896xzem5",
    payment_amount: "100",
    validator: "terra18vd8fpwxzck93qlwghaj6arh4p7c5n896xzem5",
    min_submission_value: "1",
    max_submission_value: "10000000",
    timeout: 100,
    decimals: 18,
    description: "pass",
  });
  const flagsAddr = await uploadAndInstantiate(FLAGS_PATH, {})
  const deviationFlaggingValidatorAddr = await uploadAndInstantiate(DEVIATION_FLAGGING_VALIDATOR_PATH, {
    flags: flagsAddr,
    flagging_threshold: 100000
  })

  const result = await terra.wasm.contractQuery(linkAddr, { token_info: {} });
  console.log(result)

  await updateAvailableFunds(fluxAddr);
}

async function updateAvailableFunds(address) {
  const tx = new MsgExecuteContract(mk.accAddress, address, {
    update_available_funds: {},
  });

  try {
    const result = await wallet
      .createAndSignTx({
        msgs: [tx],
      })
      .then((tx) => terra.tx.broadcast(tx));

    console.log(result.raw_log);
  } catch (error) {
    console.error(error.toString());
  }
}

async function uploadAndInstantiate(contractPath, instantiateMsg) {
  const wasm = readFileSync(contractPath);
  const tx = new MsgStoreCode(mk.accAddress, wasm.toString("base64"));

  try {
    const storeResult = await wallet
      .createAndSignTx({
        msgs: [tx]
      })
      .then((tx) => terra.tx.broadcast(tx));

    console.log(storeResult.raw_log);

    const codeId = extractCodeId(storeResult.raw_log);

    const instantiate = new MsgInstantiateContract(
      mk.accAddress,
      mk.accAddress,
      codeId,
      instantiateMsg
    );

    const instantiateResult = await wallet
      .createAndSignTx({
        msgs: [instantiate],
        memo: "Instantiating",
      })
      .then((tx) => terra.tx.broadcast(tx));

    console.log(instantiateResult.raw_log);

    return extractContractAddress(instantiateResult.raw_log);
  } catch (error) {
    console.error(error.toString());
    throw error;
  }
}

function extractCodeId(logs) {
  // TODO improve parsing
  const parsed = JSON.parse(logs);
  return Number(parsed[0]["events"][1]["attributes"][1]["value"]);
}

function extractContractAddress(logs) {
  // TODO improve parsing
  const parsed = JSON.parse(logs);
  return parsed[0]["events"][0]["attributes"][3]["value"];
}

/*
  // Store logs
  [
    {
      events: [
        {
          type: "message",
          attributes: [
            { key: "action", value: "/terra.wasm.v1beta1.MsgStoreCode" },
            { key: "module", value: "wasm" },
          ],
        },
        {
          type: "store_code",
          attributes: [
            {
              key: "sender",
              value: "terra1x46rqay4d3cssq8gxxvqz8xt6nwlz4td20k38v",
            },
            { key: "code_id", value: "8" },
          ],
        },
      ],
    },
  ];
  
  // code
  raw_logs[0]['events'][1]['attributes'][1]['value']

  // Instantiate logs
  [
    {
      events: [
        {
          type: "instantiate_contract",
          attributes: [
            {
              key: "creator",
              value: "terra1x46rqay4d3cssq8gxxvqz8xt6nwlz4td20k38v",
            },
            {
              key: "admin",
              value: "terra1x46rqay4d3cssq8gxxvqz8xt6nwlz4td20k38v",
            },
            { key: "code_id", value: "8" },
            {
              key: "contract_address",
              value: "terra175zt7t2jafkfszlfwdk28d4evt6smkmjuanpsr",
            },
          ],
        },
        {
          type: "message",
          attributes: [
            {
              key: "action",
              value: "/terra.wasm.v1beta1.MsgInstantiateContract",
            },
            { key: "module", value: "wasm" },
            {
              key: "sender",
              value: "terra1x46rqay4d3cssq8gxxvqz8xt6nwlz4td20k38v",
            },
          ],
        },
      ],
    },
  ];
  
  // contract address
  raw_logs[0]['events'][0]['attributes'][3]['value']
*/