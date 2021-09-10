const Wallet = artifacts.require("Wallet");

//var owneraddresses = [0xe0316c0adb9a686516efb545ce9225fbcf058183,0x6c78994bf2dc9c3f379f1407484394d0d4f7d36d];
var limit = 2;
module.exports = function (deployer, network, accounts) {
  deployer.deploy(Wallet,['0xe0316c0adb9a686516efb545ce9225fbcf058183','0x6c78994bf2dc9c3f379f1407484394d0d4f7d36d','0x87ee587f1ba281a7e250e83010599dec7d5fa6c8'],limit);
};
