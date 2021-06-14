import { readFileSync } from "fs";
import {
  LCDClient,
  MnemonicKey,
  MsgExecuteContract,
  MsgInstantiateContract,
  MsgStoreCode,
} from "@terra-money/terra.js";

const FLAGS_PATH = "../../terra-contracts/contracts/artifacts/flags.wasm";
const VALIDATOR_PATH =
  "../../terra-contracts/contracts/artifacts/deviation_flagging_validator.wasm";
const LINK_PATH = "../../terra-contracts/contracts/artifacts/link_token.wasm";
const FLUX_PATH =
  "../../terra-contracts/contracts/artifacts/flux_aggregator.wasm";

const ORACLES = [
  "terra1757tkx08n0cqrw7p86ny9lnxsqeth0wgp0em95",
  "terra17lmam6zguazs5q5u6z5mmx76uj63gldnse2pdp",
];

const mk = new MnemonicKey({
  mnemonic:
    "notice oak worry limit wrap speak medal online prefer cluster roof addict wrist behave treat actual wasp year salad speed social layer crew genius",
});

const terra = new LCDClient({
  URL: "http://localhost:1317",
  chainID: "localterra",
  gasPrices: { uluna: 1000000 },
});

const wallet = terra.wallet(mk);

run();

async function run() {
  const flagsAddr = await uploadAndInstantiate(FLAGS_PATH, {
    rac_address: "terra183rx7pqzjwj4mj7rxrrgv589zsfl22yeagalc0", // placeholder
  });

  const dfaAddr = await uploadAndInstantiate(VALIDATOR_PATH, {
    flags: flagsAddr,
    flagging_threshold: 5,
  });

  const linkAddr = await uploadAndInstantiate(LINK_PATH, {});

  const fluxAddr = await uploadAndInstantiate(FLUX_PATH, {
    link: linkAddr,
    payment_amount: "100",
    validator: dfaAddr,
    min_submission_value: "1",
    max_submission_value: "10000000",
    timeout: 100,
    decimals: 18,
    description: "pass",
  });

  const result = await terra.wasm.contractQuery(linkAddr, { token_info: {} });
  console.log(result);

  await sendLink(linkAddr, fluxAddr, "1000000");
  await updateAvailableFunds(fluxAddr);

  await addOracles(fluxAddr, ORACLES);

  console.table({
    LINK: linkAddr,
    FLUX_AGGREGATOR: fluxAddr,
    FLAGS: flagsAddr,
    DEVIATION_FLAGGING_AGGREGATOR: dfaAddr,
    ...ORACLES.reduce((acc, addr, i) => {
      acc[`oracle_${i}`] = addr;
      return acc;
    }, {}),
  });
}

async function sendLink(address, recipient, amount) {
  await executeContract(address, {
    send: {
      amount,
      contract: recipient,
      msg: Buffer.from("").toString("base64"),
    },
  });
}

async function addOracles(address, oracles) {
  await executeContract(address, {
    change_oracles: {
      removed: [],
      added: oracles,
      added_admins: oracles,
      min_submissions: oracles.length,
      max_submissions: oracles.length,
      restart_delay: 1,
    },
  });
}

async function setValidator(address, validator) {
  await executeContract(address, {
    set_validator: {
      validator,
    },
  });
}

async function updateAvailableFunds(address) {
  await executeContract(address, {
    update_available_funds: {},
  });
}

async function executeContract(address, msg) {
  const tx = new MsgExecuteContract(mk.accAddress, address, msg);

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
        msgs: [tx],
        memo: `Storing ${contractPath}`,
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
    process.exit(1);
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
