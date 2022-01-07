const express = require("express");
// const { body } = require("express-validator/check");

// const User = require("../models/user");
const ipfsController = require("../controller/ipfsController");

router.post("/add", ipfsController.addData);
