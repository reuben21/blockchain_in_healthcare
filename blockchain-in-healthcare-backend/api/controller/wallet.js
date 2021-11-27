const bcrypt = require("bcryptjs");
const contract = require("truffle-contract");

// const patient_contract = require("../../build/contracts/Patient.json");
// var Patient = contract(patient_contract);


exports.createWallet = (req, res, next) => { 

    var self = this;
    account = self.web3.eth.accounts.create();
    console.log(account)
    result = self.web3.eth.accounts.wallet.add({
        privateKey: account.privateKey,
        address: account.address
    })
    
    console.log(result);

    res.send(account);
}

exports.getBalanceWallet = (req, res, next) => {
    const walletAddress = req.params.walletAddress;
    console.log(walletAddress);

    var self = this;

    self.web3.eth.getBalance(walletAddress).then(result=>{
        res.send({balance:result})
    });
}

exports.sendEther = (req, res, next) => {

    const senderWalletAddress = req.body.senderWalletAddress;
    const receiverWalletAddress = req.body.receiverWalletAddress;

    var self = this;

    let send = self.web3.eth.sendTransaction({
        from:senderWalletAddress,
        to:receiverWalletAddress,
        value:self.web3.utils.toWei("20.0", "ether")
        });
    res.send(send);

}

exports.getAccountsInWallet = (req, res, next)=> {
    var self = this;

    self.web3.eth.personal.getAccounts().then(console.log);
}














































// app.get("/getAccounts", (req, res) => {
//   console.log("**** GET /getAccounts ****");
//   truffle_connect.start(function (answer) {
//     res.send(answer);
//   });
// });

// app.get("/createAccount", (req, res) => {
//   console.log("**** GET /createAccount ****");
//   truffle_connect.createWallet(function (answer) {
//     res.send(answer);
//   });
// });

// app.post("/getBalance", (req, res) => {
//   console.log("**** GET /getBalance ****");
//   console.log(req.body);
//   let currentAcount = req.body.account;

//   truffle_connect.refreshBalance(currentAcount, (answer) => {
//     let account_balance = answer;
//     truffle_connect.start(function (answer) {
//       // get list of all accounts and send it along with the response
//       let all_accounts = answer;
//       response = [account_balance, all_accounts];
//       res.send(response);
//     });
//   });
// });

// app.post("/sendCoin", (req, res) => {
//   console.log("**** GET /sendCoin ****");
//   console.log(req.body);

//   let amount = req.body.amount;
//   let sender = req.body.sender;
//   let receiver = req.body.receiver;

//   truffle_connect.sendCoin(amount, sender, receiver, (balance) => {
//     res.send(balance);
//   });
// });
