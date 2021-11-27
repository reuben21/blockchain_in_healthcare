// const { validationResult } = require("express-validator/check");
const bcrypt = require("bcryptjs");
const contract = require("truffle-contract");
const authentication = require("./auth/authentication")
const patient_contract = require("../../build/contracts/Patient.json");
var Patient = contract(patient_contract);
// const jwt = require("jsonwebtoken");

exports.signup = async (req, res, next) => {
  // const errors = validationResult(req);
  // if (!errors.isEmpty()) {
  //     const error = new Error('Validation failed.');
  //     error.statusCode = 422;
  //     error.data = errors.array();
  //     throw error;
  // }

  const name = req.body.name;
  const personalDetailsHash = req.body.personalDetailsHash;
  const hospitalAddress = req.body.hospitalAddress;
  const password = req.body.password;
  const digicode = req.body.digicode;
  const walletAddress = req.body.walletAddress;

  console.log(name + " " + personalDetailsHash + " "+hospitalAddress + " " +password+ " "+digicode+" "+walletAddress+" ") 

  const hash = await authentication.AuthenticationHash(name, walletAddress, password, digicode);


  console.log(hash)

  var self = this;

  Patient.setProvider(self.web3.currentProvider);
  var patient;
  Patient.deployed()
    .then(function (instance) {
      patient = instance;

      return patient.registerPatient(
        name,
        personalDetailsHash,
        hospitalAddress,
        walletAddress,
        hash,
        { from: walletAddress }
      );

    })
    .then(function (value) {
      console.log(value);
    })
    .catch(function (e) {
      console.log(e);
    });
};

exports.getPatientData = (req, res, next) => {
  const walletAddress = req.params.walletAddress;
  console.log(walletAddress);
  // const walletAddress = req.body.walletAddress;
  var self = this;

  Patient.setProvider(self.web3.currentProvider);
  var patient;

  Patient.deployed()
    .then(function (instance) {
      patient = instance;

      return patient.getPatientData.call(walletAddress, {
        from: walletAddress,
      });

    })
    .then(function (value) {
      console.log(value);
      res.send(value);
    })
    .catch(function (e) {
      console.log(e);
    });
};
