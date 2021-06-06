import {
  LCDClient,
  MsgStoreCode,
  MnemonicKey,
  isTxError,
} from "@terra-money/terra.js";
import * as fs from "fs";

let contracts = [
  {
    name: "owned",
    uploaded: false,
    addr: "",
  },
  {
    name: "flags",
    uploaded: false,
    addr: "",
  },
];

const mk = new MnemonicKey({
  mnemonic:
    "notice oak worry limit wrap speak medal online prefer cluster roof addict wrist behave treat actual wasp year salad speed social layer crew genius",
});

const terra = new LCDClient({
  URL: process.env.TERRA_HOST as string,
  chainID: process.env.CHAIN_ID as string,
});

console.log(terra);

const wallet = terra.wallet(mk);

const owned = new MsgStoreCode(
  wallet.key.accAddress,
  fs.readFileSync(`./contracts/artifacts/owned.wasm`).toString("base64")
)

const storeCodeTx = async () => {
  return await wallet.createAndSignTx({
    msgs: [owned],
  });
};

storeCodeTx()
