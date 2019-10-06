const HDWalletProvider = require('truffle-hdwallet-provider')

require('dotenv').config();

//const MNEMONIC = process.env.MNENOMIC;
const INFURA_API_KEY = process.env.INFURA_API_KEY;

module.exports = {
  networks: {
    cldev: {
      host: '127.0.0.1',
      port: 7545,   // Ganache-GUI
      //port: 8545, // Ganache-CLI
      network_id: '*',
    },
    live: {  // Ropsten
      provider: () => {
        //return new HDWalletProvider("Put your MNEMONIC to here", process.env.RPC_URL)
        return new HDWalletProvider(process.env.MNEMONIC, process.env.RPC_URL)
      },
      network_id: '*',
      // Necessary due to https://github.com/trufflesuite/truffle/issues/1971
      // Should be fixed in Truffle 5.0.17
      skipDryRun: true,
      //gas:  3000000,
      //gasPrice: 4500000000,
      //from: "0x245385e312306042099Bd0F622500806E6e1D9b6"   // @dev If we want to change owner address of deploy, we need to specify the prefer account address at here. 
    },
  },
  compilers: {
    solc: {
      version: '0.4.24',
    },
  },
}
