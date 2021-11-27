const express = require("express");
// const { body } = require("express-validator/check");

// const User = require("../models/user");
const patientController = require("../controller/Patient/patient");
// const isAuth = require("../middleware/is-auth");

const router = express.Router();

router.post("/data", patientController.signup);

router.get("/data/:walletAddress", patientController.getPatientData);

module.exports = router;
