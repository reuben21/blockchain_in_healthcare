const bcrypt = require("bcryptjs");
const contract = require("truffle-contract");

const hospital_contract = require("../../build/contracts/HospitalCoin.json");
var HospitalCoin = contract(hospital_contract);

exports.getCoinBalance = (req, res, next) => {
  const walletAddress = req.params.walletAddress;
  console.log(walletAddress);
  // const walletAddress = req.body.walletAddress;
  var self = this;

  HospitalCoin.setProvider(self.web3.currentProvider);
  var hospitalCoin;
  HospitalCoin.deployed()
    .then(function (instance) {
      hospitalCoin = instance;
      return hospitalCoin.balanceOf.call(
        walletAddress
        //     , {
        //   from: walletAddress,
        // }
      );
    })
    .then(function (value) {
      console.log();
      var bln = value.words.join("");
      res.send({
        balance: bln,
      });
    })
    .catch(function (e) {
      console.log(e);
    });
};

exports.getTotalSupply = (req, res, next) => {
  var self = this;
  HospitalCoin.setProvider(self.web3.currentProvider);
  var hospitalCoin;
  HospitalCoin.deployed()
    .then(function (instance) {
      hospitalCoin = instance;
      return hospitalCoin.totalSupply.call();
    })
    .then(function (value) {
      console.log();
      var bln = value.words.join("");
      res.send({
        balance: bln,
      });
    })
    .catch(function (e) {
      console.log(e);
    });
};

exports.getCoinName = (req, res, next) => {
  var self = this;
  HospitalCoin.setProvider(self.web3.currentProvider);
  var hospitalCoin;
  HospitalCoin.deployed()
    .then(function (instance) {
      hospitalCoin = instance;
      return hospitalCoin.name.call();
    })
    .then(function (value) {
      console.log(value);
      res.send({
        "Coin Name": value,
      });
    })
    .catch(function (e) {
      console.log(e);
    });
};

exports.getCoinSymbol = (req, res, next) => {
  var self = this;
  HospitalCoin.setProvider(self.web3.currentProvider);
  var hospitalCoin;
  HospitalCoin.deployed()
    .then(function (instance) {
      hospitalCoin = instance;
      return hospitalCoin.symbol.call();
    })
    .then(function (value) {
      res.send({
        "Coin Symbol": value,
      });
    })
    .catch(function (e) {
      console.log(e);
    });
};
