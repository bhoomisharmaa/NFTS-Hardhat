import type { HardhatUserConfig } from "hardhat/config";
import hardhatVerify from "@nomicfoundation/hardhat-verify";
import hardhatToolboxMochaEthersPlugin from "@nomicfoundation/hardhat-toolbox-mocha-ethers";
import hardhatEthers from "@nomicfoundation/hardhat-ethers";
import * as dotenv from "dotenv";
dotenv.config();

const PRIVATE_KEY_ACCOUNT_1 = process.env.PRIVATE_KEY_ACCOUNT_1 ?? "";
const PRIVATE_KEY_ACCOUNT_2 = process.env.PRIVATE_KEY_ACCOUNT_2 ?? "";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY ?? "";
const SEPOLIA_RPC_URL = process.env.SEPOLIA_RPC_URL ?? "";

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxMochaEthersPlugin, hardhatVerify, hardhatEthers],
  solidity: {
    profiles: {
      default: {
        version: "0.8.28",
      },
      production: {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    },
  },
  networks: {
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
    hardhatOp: {
      type: "edr-simulated",
      chainType: "op",
    },
    sepolia: {
      type: "http",
      chainType: "l1",
      url: SEPOLIA_RPC_URL as any,
      accounts: [PRIVATE_KEY_ACCOUNT_1 as any, PRIVATE_KEY_ACCOUNT_2 as any],
    },
  },

  verify: {
    etherscan: {
      apiKey: ETHERSCAN_API_KEY as any,
      enabled: true,
    },
  },
};

export default config;
