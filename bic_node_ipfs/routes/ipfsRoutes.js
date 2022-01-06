const express = require("express");

const ipfsController = require("../controller/ipfsController");

const router = express.Router();

router.post("/add", ipfsController.ipfsAdd);

module.exports = router;