import { readFileSync, writeFileSync, appendFileSync } from "fs";

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
  "terra199vw7724lzkwz6lf2hsx04lrxfkz09tg8dlp6r"
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
  console.log("Uploading Flags and Deviation Flagging Validator...");
  const flagsCodeId = await upload(FLAGS_PATH)
    
  const dfvCodeId = await upload(VALIDATOR_PATH)
  
  console.log("Uploading and instantiating LINK Token...");
  const linkAddr = await uploadAndInstantiate(LINK_PATH, {});

  const result = await terra.wasm.contractQuery(linkAddr, { token_info: {} });
  console.log(result);

  console.log("Uploading Flux Aggregator...");
  const faCodeId = await upload(FLUX_PATH)
  
 
  const deployedContracts = {
    LINK: linkAddr,
    FLUX_AGGREGATOR: faCodeId,
    FLAGS: flagsCodeId,
    DEVIATION_FLAGGING_VALIDATOR: dfvCodeId
  };
  console.table(deployedContracts);

  writeFileSync("./addresses.json", JSON.stringify(deployedContracts));
  await addFeed(
    {
        payment_amount: "100",
        min_submission_value: "100000000",
        max_submission_value: "10000000000",
        timeout: 100,
        decimals: 8,
        description: "LINK/USD",
    }
  )
  await addFeed(
    {
        payment_amount: "100",
        min_submission_value: "100000000",
        max_submission_value: "10000000000",
        timeout: 100,
        decimals: 8,
        description: "LUNA/USD",
    }
  )
}

async function addFeed(feedDetails) {
  console.log("Adding feed: ", feedDetails)
  const addresses = JSON.parse(readFileSync('addresses.json', { encoding: 'utf8' }));
  console.log("Instantiating Flags...");

  const flagsInstance = await instantiate(addresses['FLAGS'], {
    rac_address: "terra183rx7pqzjwj4mj7rxrrgv589zsfl22yeagalc0", // placeholder
  });
  console.log("Instantiating Deviation Flagging Validator...");

  const dfvInstance = await instantiate(addresses['DEVIATION_FLAGGING_VALIDATOR'], {
    flags: flagsInstance,
    flagging_threshold: 5,
  });
  console.log("Instantiating Flux Aggregator...");

  const faInstance = await instantiate(addresses['FLUX_AGGREGATOR'], {
    link: addresses['LINK'],
    validator: dfvInstance,
    ...feedDetails
  });

  console.log("Supplying Flux Aggregator with LINK...");
  await sendLink(addresses['LINK'], faInstance, "1000000");
  await updateAvailableFunds(faInstance);

  console.log(`Adding oracles: ${ORACLES}`);
  await addOracles(faInstance, ORACLES);
  const deployedContracts = {
      FLUX_AGGREGATOR: faInstance,
      FLAGS: flagsInstance,
      DEVIATION_FLAGGING_VALIDATOR: dfvInstance,
      ...ORACLES.reduce((acc, addr, i) => {
        acc[`oracle_${i}`] = addr;
        return acc;
      }, {}),
    }
  console.log("Instantiation of feed: ", feedDetails.description)
  console.table(deployedContracts);

  writeFileSync(`./addresses-${feedDetails.description.replace('/','')}.json`, JSON.stringify(deployedContracts));
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

async function transferLink(address, recipient, amount) {
  await executeContract(address, {
    transfer: {
      amount,
      recipient,
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
      restart_delay: 0,
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
    process.exit(2);
  }
}

async function uploadAndInstantiate(contractPath, instantiateMsg) {
  try {
    const codeId = await upload(contractPath)
    const contractAddress = await instantiate(codeId, instantiateMsg)
    return contractAddress
  } catch (error) {
    console.error(error.toString());
    process.exit(1);
  }
}

async function upload(contractPath) {
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
    return codeId;
  } catch (error) {
    console.error(error.toString());
    process.exit(1);
  }
}

async function instantiate(codeId, instantiateMsg) {
  try {
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
