const express = require("express");
const app = express();
const port = 3000 || process.env.PORT;
const Web3 = require("web3");
const bodyParser = require("body-parser");

//  CONNECT WEB3 TO CONTROLLER
const wallet_connect = require("./api/controller/wallet");
const hospital_coin_connect = require("./api/controller/hospitalCoin");

//  ROUTES
const walletRoutes = require("./api/routes/wallet");


// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.use("/", express.static("public_static"));

app.use("/wallet", walletRoutes);

app.use("/ipfs", walletRoutes);

app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET, POST, PUT, PATCH, DELETE');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    next();
});

























app.listen(port, () => {
  // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
  var HttpProvider = "http://127.0.0.1:7545";
  
  wallet_connect.web3 = new Web3(
    new Web3.providers.HttpProvider(HttpProvider)
  );

  console.log("Express Listening at http://localhost:" + port);
});
