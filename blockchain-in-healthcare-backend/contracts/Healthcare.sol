//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";
import "./Patient.sol";
import "./Doctor.sol";
import "./Hospital.sol";
import "./Pharmacy.sol";

contract Healthcare is AccessControl {
    //: Constructor
    constructor() {
        _setRoleAdmin(HOSPITAL_ADMIN, HOSPITAL_ADMIN);
        _setRoleAdmin(DOCTOR, HOSPITAL_ADMIN);
        _setRoleAdmin(PATIENT, HOSPITAL_ADMIN);

        // default role of contract deployer
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // contract address - needed to access other contacts and call functions from other contracts
    address patientContractAddress;
    address doctorContractAddress;
    address hospitalContractAddress;
    address pharmacyContractAddress;

    function setPatientContractAddress(address _patientAddress) external {
        patientContractAddress = _patientAddress;
    }

    function setDoctorContractAddress(address _doctorAddress) external {
        doctorContractAddress = _doctorAddress;
    }

    function setHospitalContractAddress(address _hospitalContractAddress)
        external
    {
        hospitalContractAddress = _hospitalContractAddress;
    }

    function setPharmacyContractAddress(address _pharmacyContractAddress)
        external
    {
        pharmacyContractAddress = _pharmacyContractAddress;
    }

    // Register functions for all entities

    function registerPatient(
        string memory _name,
        string memory _personalDetails,
        address _hospitalAddress,
        address addressOfUser,
        string memory _hash
    ) public returns (string memory status) {
        _setupRole(PATIENT, addressOfUser);
        Patient P = Patient(patientContractAddress);
        return
            P.registerPatient(
                _name,
                _personalDetails,
                _hospitalAddress,
                addressOfUser,
                _hash
            );
    }

    function registerDoctor(
        string memory _name,
        string memory _personalDetails,
        address _hospitalAddress,
        address addressOfUser
    ) public returns (string memory status) {
        _setupRole(DOCTOR, addressOfUser);
        Doctor D = Doctor(doctorContractAddress);
        return
            D.registerDoctor(
                _name,
                _personalDetails,
                _hospitalAddress,
                addressOfUser
            );
    }

    function registerHospital(
        string memory _name,
        string memory _hospitalDetails,
        address _hospitalAddress
    ) public returns (string memory status) {
        _setupRole(HOSPITAL_ADMIN, _hospitalAddress);
        Hospital H = Hospital(hospitalContractAddress);
        return H.registerHospital(_name, _hospitalDetails, _hospitalAddress);
    }

    function registerPharmacy(
        string memory _name,
        string memory _personalDetails,
        address addressOfUser
    ) public returns (string memory status) {
        _setupRole(PHARMACY, addressOfUser);
        Pharmacy Ph = Pharmacy(pharmacyContractAddress);
        return Ph.registerPharmacy(_name, _personalDetails, addressOfUser);
    }

    // Get Data With Respect To Single Entity : functions
    function getPatientData(address _addressOfPatient)
        public
        view
        returns (
            string memory name,
            string memory personalDetails,
            address Address
        )
    {
        require(hasRole(VERIFIED_PATIENT, _addressOfPatient));
        Patient P = Patient(patientContractAddress);
        return P.getPatientData(_addressOfPatient);
    }

    function getDoctorData(
        address addressOfUser,
        address _addressOfHigherAuthority
    )
        public
        view
        returns (
            string memory name,
            string memory personalDetails,
            address Address
        )
    {
        require(
            hasRole(DOCTOR, addressOfUser) ||
                hasRole(VERIFIED_DOCTOR, addressOfUser) ||
                hasRole(HOSPITAL_ADMIN, addressOfUser)
        );
        Doctor D = Doctor(doctorContractAddress);
        return D.getDoctorData(addressOfUser, _addressOfHigherAuthority);
    }

    function getHospitalData(address addressOfHospital)
        public
        view
        returns (
            string memory _nameAdmin,
            string memory hospitalDetails,
            address walletAddress
        )
    {
        require(hasRole(HOSPITAL_ADMIN, addressOfHospital));
        Hospital H = Hospital(hospitalContractAddress);
        return H.getHospitalData(addressOfHospital);
    }

    function getPharmacyData(address addressOfPharmacy)
        public
        view
        returns (
            string memory pharmacyName,
            string memory pharmacyDetails,
            address pharmacyWalletAddress
        )
    {
        Pharmacy Ph = Pharmacy(pharmacyContractAddress);
        return Ph.getPharmacyData(addressOfPharmacy);
    }

    function updatePatientPersonalData(
        address _walletAddress,
        string memory _personalDetails
    ) public returns (bool success) {
        Patient P = Patient(patientContractAddress);
        return P.updatePatientPersonalData(_walletAddress, _personalDetails);
    }

    function updatePatientMedicalRecords(
        address _patientAddress,
        address _addressOfHigherAuthority,
        string memory medicalRecordHash
    ) external returns (string memory status) {
        require(hasRole(VERIFIED_DOCTOR, _addressOfHigherAuthority));
        Patient P = Patient(patientContractAddress);
        return
            P.updatePatientMedicalRecords(_patientAddress, medicalRecordHash);
    }

    function updatePrescriptionToPatient(
        address _patientAddress,
        address _addressOfHigherAuthority,
        string memory prescriptionHash
    ) external returns (string memory status) {
        require(hasRole(VERIFIED_DOCTOR, _addressOfHigherAuthority));
        Patient P = Patient(patientContractAddress);
        return P.updatePatientPrescription(_patientAddress, prescriptionHash);
    }

    function getNewPrescription(address _patientAddress)
        external
        view
        returns (string memory status)
    {
        Patient P = Patient(patientContractAddress);
        return P.getNewPrescription(_patientAddress);
    }

    function getMultiplePrescription(address _patientAddress)
        external
        view
        returns (string[] memory status)
    {
        Patient P = Patient(patientContractAddress);
        return P.getMultiplePrescription(_patientAddress);
    }

    function getNewRecords(address _patientAddress)
        external
        view
        returns (string memory status)
    {
        Patient P = Patient(patientContractAddress);
        return P.getNewRecords(_patientAddress);
    }

    function getMultipleRecords(address _patientAddress)
        external
        view
        returns (string[] memory status)
    {
        Patient P = Patient(patientContractAddress);
        return P.getMultipleRecords(_patientAddress);
    }

    // Grant Role VERIFIED_PATIENT To Patient
    function grantRoleVerifiedPatient(
        address _addressOfAdmin,
        address _addressOfPatient
    ) public returns (bool success) {
        require(
            hasRole(HOSPITAL_ADMIN, _addressOfAdmin) ||
                hasRole(VERIFIED_DOCTOR, _addressOfAdmin)
        );
        require(hasRole(PATIENT, _addressOfPatient));
        grantRole(VERIFIED_PATIENT, _addressOfPatient);
        return true;
    }

    // Grant Role VERIFIED_DOCTOR to Doctor
    function grantRoleVerifiedDoctor(
        address _addressOfAdmin,
        address _addressOfDoctor
    ) public returns (bool success) {
        require(hasRole(HOSPITAL_ADMIN, _addressOfAdmin));
        require(hasRole(DOCTOR, _addressOfDoctor));
        grantRole(VERIFIED_DOCTOR, _addressOfDoctor);
        return true;
    }

    function fetchPrescriptionDetailsPharmacy(
        address _patientAddress,
        address _addressOfHigherAuthority
    ) external view returns (string memory prescriptionHash) {
        require(
            hasRole(PHARMACY, _addressOfHigherAuthority) ||
                hasRole(VERIFIED_DOCTOR, _addressOfHigherAuthority) ||
                hasRole(VERIFIED_PATIENT, _addressOfHigherAuthority)
        );

        Patient P = Patient(patientContractAddress);
        return P.getNewPrescription(_patientAddress);
    }

    function getEthBalance(address _addr) external view returns (uint256) {
        return _addr.balance;
    }

    function transferMoney(
        address _senderAddress,
        address payable _receiverAddress,
        uint256 _amount
    ) external {
        require(msg.sender == _senderAddress);
        _receiverAddress.transfer(_amount);
    }
}
