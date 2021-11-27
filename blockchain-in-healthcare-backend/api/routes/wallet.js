const express = require("express");
// const { body } = require("express-validator/check");

// const User = require("../models/user");
const walletController = require("../controller/wallet");
// const isAuth = require("../middleware/is-auth");

const router = express.Router();

router.post("/create", walletController.createWallet);

router.post("/send/ether", walletController.sendEther);

router.get("/balance/:walletAddress", walletController.getBalanceWallet);

router.get("/get/accounts", walletController.getAccountsInWallet);

// router.get("/data/:walletAddress", patientController.getPatientData);

module.exports = router;
