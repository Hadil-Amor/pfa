var OrganDoanation = artifacts.require("OrganDoanation");
module.exports = async function(deployer) {
  // deploy a contract
  await deployer.deploy(OrganDoanation);
  //access information about your deployed contract instance
  var instance = await OrganDoanation.deployed();
}