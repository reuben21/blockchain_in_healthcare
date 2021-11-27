const express = require("express");
// const { body } = require("express-validator/check");

// const User = require("../models/user");
const hospitalCoinController = require("../controller/hospitalCoin");
// const isAuth = require("../middleware/is-auth");

const router = express.Router();

// router.post("/create", hospitalCoinController.createWallet);

// router.post("/send/ether", hospitalCoinController.sendEther);

router.get("/balance/:walletAddress", hospitalCoinController.getCoinBalance);

router.get("/balance/total/supply", hospitalCoinController.getTotalSupply);

router.get("/balance/total/supply", hospitalCoinController.getTotalSupply);

router.get("/name", hospitalCoinController.getCoinName);

router.get("/symbol", hospitalCoinController.getCoinSymbol);

// router.get("/get/accounts", hospitalCoinController.getAccountsInWallet);

// router.get("/data/:walletAddress", patientController.getPatientData);

module.exports = router;
