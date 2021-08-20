
import { readFileSync } from "fs";

import {
  LCDClient
} from "@terra-money/terra.js";

// make this use env vars
const terra = new LCDClient({
  URL: 'http://localhost:1317',
  chainID: 'localterra ',
  gasPrices: { uluna: 1000000},
});

run();

async function run() {
  const addresses = JSON.parse(readFileSync('addresses.json', { encoding: 'utf8' }));
  Object.entries(addresses.contracts).forEach(async c => {
      const result = await terra.wasm.contractQuery(c[1].aggregator, { get_latest_round_data: {} });
      console.log(`${c[1].name} answer:`)
      console.log(result)
    }
  )
}

