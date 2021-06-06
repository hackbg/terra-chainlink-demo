import {
  LCDClient,
  MsgStoreCode,
  MnemonicKey,
  isTxError,
} from "@terra-money/terra.js";
import * as fs from "fs";

const mk = new MnemonicKey({
  mnemonic:
    "notice oak worry limit wrap speak medal online prefer cluster roof addict wrist behave treat actual wasp year salad speed social layer crew genius",
});

const terra = new LCDClient({
  URL: process.env.TERRA_HOST,
  chainID: process.env.CHAIN_ID,
});

const wallet = terra.wallet(mk);
