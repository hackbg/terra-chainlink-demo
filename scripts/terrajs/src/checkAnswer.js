import { readFileSync } from "fs";

import {
  LCDClient
} from "@terra-money/terra.js";

import dotenv from "dotenv"
import path from "path";

dotenv.config({path: path.resolve(__dirname, "..", "..", "..", ".env")})

const terra = new LCDClient({
  URL: process.env.NODE_URL.replace("terrad", "localhost"),
  chainID: process.env.CHAIN_ID,
  gasPrices: { uluna: process.env.DEFAULT_GAS_PRICE },
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

