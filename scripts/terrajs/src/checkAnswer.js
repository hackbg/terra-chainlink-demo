
import { readFileSync } from "fs";

import {
  LCDClient
} from "@terra-money/terra.js";

const terra = new LCDClient({
  URL: "http://localhost:1317",
  chainID: "localterra",
  gasPrices: { uluna: 1000000 },
});

run();

async function run() {
  const addresses = JSON.parse(readFileSync('addresses.json', { encoding: 'utf8' }));
  const result = await terra.wasm.contractQuery(addresses['FLUX_AGGREGATOR'], { get_latest_round_data: {} });
  console.log(result);
}

