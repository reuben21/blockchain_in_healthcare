const Web3 = require("web3");
var web3 = new Web3('http://localhost:7545');

// const rolesContractAbi = require("../bic_android_web_support/assets/abis/Roles.json");
// const patientContractAbi = require("../bic_android_web_support/assets/abis/Patient.json");
// const pharmacyContractAbi = require("../bic_android_web_support/assets/abis/Pharmacy.json");
// const doctorContractAbi = require("../bic_android_web_support/assets/abis/Doctor.json");
// const hospitalTokenContractAbi = require("../bic_android_web_support/assets/abis/HospitalToken.json");
// const hospitalContractAbi = require("../bic_android_web_support/assets/abis/Hospital.json");
const MainContractAbi = require("../bic_android_web_support/assets/abis/MainContract.json");

// const rolesContract = new web3.eth.Contract(rolesContractAbi['abi'], rolesContractAbi['networks']['5777']['address'])
// const hospitalTokenContract = new web3.eth.Contract(hospitalTokenContractAbi['abi'], hospitalTokenContractAbi['networks']['5777']['address'])

const mainContract = new web3.eth.Contract(MainContractAbi['abi'], MainContractAbi['networks']['5777']['address'])
// const doctorContract = new web3.eth.Contract(doctorContractAbi['abi'], doctorContractAbi['networks']['5777']['address'])
// const patientContract = new web3.eth.Contract(patientContractAbi['abi'], patientContractAbi['networks']['5777']['address'])

// const pharmacyContract = new web3.eth.Contract(pharmacyContractAbi['abi'], pharmacyContractAbi['networks']['5777']['address'])
// console.log(hospitalTokenContractAbi['networks']['5777']['address'])
// transfer ether from ganache account to Doctor, Hospital, Patient

// ganache account address

const ganacheWalletAddress = "0xdAe7aeA268681a007Cd20DbDAA9F9D9dA5A475e7";

// Using Hospital Token Contract to Approve Other Contracts

// hospitalTokenContract.methods.approve(MainContractAbi['networks']['5777']['address'],100000).send({from:ganacheWalletAddress}).then(console.log)



// Linking the Contracts

// hospitalTokenContract.methods.setContractAddresss(MainContractAbi['networks']['5777']['address']).send({from:ganacheWalletAddress}).then(console.log)

// mainContract.methods.setContractAddresss(
//         MainContractAbi['networks']['5777']['address']
//         ).send({from:ganacheWalletAddress}).then(console.log)


// // FROM GANACHE TO PATIENT A
const transaction1 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0x138d4f45a4f44bfd297503bbbdc9aedb941df3d3",
        value: web3.utils.toWei("12.0", "ether")
});

// console.log(transaction1);

// FROM GANACHE TO DOCTOR A
const transaction2 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0x19a6b08cb325e55783e860fadb33ae87ad370e80",
        value: web3.utils.toWei("14.0", "ether")
});

// console.log(transaction2);
// FROM GANACHE TO HOSPITAL A
const transaction3 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0x2f92dcd68b6c0145774279b9c4166efa8d0df364",
        value: web3.utils.toWei("16.0", "ether")
});


// console.log(transaction2);
// FROM GANACHE TO PHARMACY A
const transaction4 = web3.eth.sendTransaction({
        from: ganacheWalletAddress,
        to: "0x9f85457ae0622b8db4ff3c9554605e1416d6aad2",
        value: web3.utils.toWei("18.0", "ether")
});

// console.log(transaction3);

const hospial_A_Address = "0xd65ba9b459d339287cd5bb2beb17435f4e20dfb5"
const doctor_A_Address = "0x386142cccf4b085024c2e7aee39b38cd64e653d2"
const patient_A_Address = "0xf9ad512430f7e6694d22a830da8cea7d1bb0eb5d"
// hospitalContract.methods.storeHospital(
//         "Hospital A",
//         "Qmb5xSHLW9frRSWvN1gxdfvwTby7SxXsb1RRjc4hA3Sf4k",
//         hospial_A_Address

//         ).send({from:hospial_A_Address}).then(console.log("Stored Hospial Details"));

// doctorContract.methods.storeDoctor(
//         "Doctor A",
//         "QmeS2f4oM6pQDMvTdbovtwYrEswyGdbhi41zRBCpz2Brgi",
//         hospial_A_Address,
//         doctor_A_Address
//         ).send({from:doctor_A_Address}).then(console.log("Stored Doctor Details"));

// rolesContract.methods.grantRoleFromHospital(
       
//         hospial_A_Address,
//         doctor_A_Address,
//         "VERIFIED_DOCTOR"

//         ).send({from:hospial_A_Address}).then(console.log("Granted Role To Doctor"));


// patientContract.methods.storePatient(
//         "Patient A",
//         "Hashh",
//         hospial_A_Address,
//         doctor_A_Address,
//         patient_A_Address
//         ).send({from:patient_A_Address}).then(value=>console.log)