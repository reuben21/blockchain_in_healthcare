const Web3 = require("web3");
var web3 = new Web3('http://localhost:7545');



// transfer ether from ganache account to Doctor, Hospital, Patient

// ganache account address

const ganacheWalletAddress = "0x46C92272e5000D9dCAB46A3F384Cc5aa40d38498";


// FROM GANACHE TO PATIENT A
const transaction1 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0xf9ad512430f7e6694d22a830da8cea7d1bb0eb5d",
        value: web3.utils.toWei("20.0", "ether")
});

console.log(transaction1);

// FROM GANACHE TO DOCTOR A
const transaction2 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0x386142cccf4b085024c2e7aee39b38cd64e653d2",
        value: web3.utils.toWei("20.0", "ether")
});

console.log(transaction2);
// FROM GANACHE TO HOSPITAL A
const transaction3 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0xd65ba9b459d339287cd5bb2beb17435f4e20dfb5",
        value: web3.utils.toWei("20.0", "ether")
});

console.log(transaction3);
