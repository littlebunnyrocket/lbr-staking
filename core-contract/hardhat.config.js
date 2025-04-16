require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
    overrides: {
      "contracts/LBRETH.sol": {
        version: "0.6.12",
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
    "rise-testnet": {
      url: process.env.RISE_RPC || "https://testnet.riselabs.xyz",
      chainId: 11155931,
      accounts: [process.env.PRIVATE_KEY],
      timeout: 100000 
    },
  },

  etherscan: {
    apiKey: {
      "rise-testnet": "empty",
    },
    customChains: [
      {
        network: "rise-testnet",
        chainId: 11155931,
        urls: {
          apiURL: "https://explorer.testnet.riselabs.xyz/api",
          browserURL: "https://explorer.testnet.riselabs.xyz",
        },
      },
    ],
  },

  sourcify: {
    enabled: true,
    apiUrl: "https://explorer.testnet.riselabs.xyz/api",
    browserUrl: "https://explorer.testnet.riselabs.xyz",
  },
};
