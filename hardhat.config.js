// require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-waffle");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config()
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks:{
    localhost:{
      
    },
    testnet:{
      url:"https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId:97,
      gasPrice:20000000000,
      accounts:[`0x${process.env.PRIVATE_KEY}`]
    }
  },
  etherscan:{
    apiKey:"7UAA26XGSSJ6T1K55IABQH6NPGJP9WENBX"
  }
};
