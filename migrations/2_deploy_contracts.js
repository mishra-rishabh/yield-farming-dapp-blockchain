const DappToken = artifacts.require("DappToken");
const DaiToken = artifacts.require("DaiToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function (deployer, network, accounts) {

  // deploy mock dai token
  await deployer.deploy(DaiToken);
  // fetch the dai token from the network 
  const daiToken = await DaiToken.deployed();

  // deploy dapp token
  await deployer.deploy(DappToken);
  // fetch the dapp token from the network 
  const dappToken = await DappToken.deployed();

  // deploy token farm
  await deployer.deploy(TokenFarm, dappToken.address, daiToken.address);
  const tokenFarm = await TokenFarm.deployed();

  // deployer.deploy(TokenFarm);

  // transfer all the tokens to token farm
  await dappToken.transfer( tokenFarm.address , '1000000000000000000000000' ) ;

  // transfer 100 mock dai tokens to an investor
  await daiToken.transfer( accounts[ 1 ] , '100000000000000000000' ) ;
};
