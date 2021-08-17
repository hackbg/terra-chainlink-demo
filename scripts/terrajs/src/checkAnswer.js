
import { readFileSync } from "fs";

import {
  LCDClient
} from "@terra-money/terra.js";

const terra = new LCDClient({
  URL: "http://localhost:1317",
  chainID: "localterra",
  gasPrices: { uluna: 0.15 },
});

run();

async function run() {
  const addressesLINKUSD = JSON.parse(readFileSync('addresses-LINKUSD.json', { encoding: 'utf8' }));
  const resultLINKUSD = await terra.wasm.contractQuery(addressesLINKUSD['AGGREGATOR_PROXY'], { get_latest_round_data: {} });
  console.log("LINK / USD answer:");
  console.log(resultLINKUSD);

  const addressesLUNAUSD = JSON.parse(readFileSync('addresses-LUNAUSD.json', { encoding: 'utf8' }));
  const resultLUNAUSD = await terra.wasm.contractQuery(addressesLUNAUSD['AGGREGATOR_PROXY'], { get_latest_round_data: {} });
  console.log("LUNA / USD answer:");
  console.log(resultLUNAUSD);
}

