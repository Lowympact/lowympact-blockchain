const Actor = artifacts.require("Actor");
const Transaction = artifacts.require("Transaction");

module.exports = function (deployer) {
    deployer.deploy(Actor);
    deployer.deploy(Transaction);
};
