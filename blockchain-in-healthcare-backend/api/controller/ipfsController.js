


exports.createWallet = (req, res, next) => { 
   const password = req.body.password;
  
    var self = this;
    account = self.web3.eth.accounts.create();
    console.log(account.address)
    result = self.web3.eth.accounts.wallet.add({
        privateKey: account.privateKey,
        address: account.address
    })
    var encryptedWallet = self.web3.eth.accounts.encrypt(result.privateKey,password);
    res.send(encryptedWallet);
}