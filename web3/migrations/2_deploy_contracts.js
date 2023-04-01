var OrganTransplantation = artifacts.require("OrganTransplantation");
module.exports = async function(deployer) {
  // deploy a contract
  await deployer.deploy(OrganTransplantation);
  //access information about your deployed contract instance
  var instance = await OrganTransplantation.deployed();
}