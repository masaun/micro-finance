const MyContract = artifacts.require('MyContract')

/* Ropsten test-network */

/*
  This script allows for a Chainlink request to be created from
  the requesting contract. Defaults to the Chainlink oracle address
  on this page: https://docs.chain.link/docs/testnet-oracles
*/

const oracleAddress = process.env.TRUFFLE_CL_BOX_ORACLE_ADDRESS || '0xc99B3D447826532722E41bc36e644ba3479E4365'
const jobId = process.env.TRUFFLE_CL_BOX_JOB_ID || '9f0406209cf64acda32636018b33de11'
const payment = process.env.TRUFFLE_CL_BOX_PAYMENT || '1000000000000000000'
const url = process.env.TRUFFLE_CL_BOX_URL || 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD'
//const url = process.env.TRUFFLE_CL_BOX_URL || 'https://api.bancor.network/0.1/currencies/convertiblePairs'  // Using Bancor API
const path = process.env.TRUFFLE_CL_BOX_JSON_PATH || 'USD'
const times = process.env.TRUFFLE_CL_BOX_TIMES || '100'

module.exports = async callback => {
  const mc = await MyContract.deployed()
  console.log('Creating request on contract:', mc.address)
  const tx = await mc.createRequestTo(
    oracleAddress,
    web3.utils.toHex(jobId),
    payment,
    url,
    path,
    times,
  )
  callback(tx.tx)
}
