const Sofi = artifacts.require("Sofi");

module.exports = function (deployer) {
  deployer.deploy(Sofi);
};
