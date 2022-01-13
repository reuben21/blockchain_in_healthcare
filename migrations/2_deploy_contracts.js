// var HospitalContract = artifacts.require("./Hospital.sol");
// var PatientContract = artifacts.require("./Patient.sol");
// var DoctorContract = artifacts.require("./Doctor.sol");
// var PharmacyContract = artifacts.require("./Pharmacy.sol");
// var HealthcareContract = artifacts.require("./Healthcare.sol");
var MainContract = artifacts.require("./MainContract.sol");
// var Roles = artifacts.require("./Roles.sol");

// var HospitalCoinContract = artifacts.require("./HospitalToken.sol");

module.exports = function (deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(Roles);
  // deployer.deploy(HospitalContract);
  // deployer.deploy(PatientContract);
  // deployer.deploy(DoctorContract);
  // deployer.deploy(PharmacyContract);

  // deployer.link(Roles, PatientContract);
  // deployer.link(Roles, HospitalContract);
  // deployer.link(Roles, PatientContract);
  // deployer.link(Roles, DoctorContract);
  // deployer.link(Roles, PharmacyContract);
  // deployer.link(Roles, HealthcareContract);

  // deployer.link(PatientContract, DoctorContract);

  // deployer.link(HospitalContract,HealthcareContract);
  // deployer.link(PatientContract,HealthcareContract);
  // deployer.link(DoctorContract,HealthcareContract);
  // deployer.link(PharmacyContract,HealthcareContract);
  
  deployer.deploy(MainContract);



  // deployer.deploy(HospitalCoinContract);

};
