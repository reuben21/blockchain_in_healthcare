pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./openzeppelin/contracts/utils/Counters.sol";
import "./openzeppelin/contracts/access/AccessControlEnumerable.sol";

bytes32 constant PATIENT = "PATIENT";
bytes32 constant VERIFIED_PATIENT = "VERIFIED_PATIENT";

bytes32 constant DOCTOR = "DOCTOR";

bytes32 constant PHARMACY = "PHARMACY";

bytes32 constant HOSPITAL_ADMIN = "HOSPITAL_ADMIN";

contract MainContract is AccessControlEnumerable {
    using Counters for Counters.Counter;

    struct MedicalRecord {
        uint256 index;
        string patientRecordHash;
        bool verified;
    }

    struct Prescription {
        uint256 index;
        string prescriptionHash;
        bool verified;
    }

    struct patientRecord {
        string name;
        string personalDetails;
        address doctorAddress;
        address hospitalAddress;
        address walletAddress;
        uint256 medicalRecordCount;
        mapping(uint256 => MedicalRecord) medicalRecords;
        uint256 prescriptionCount;
        mapping(uint256 => Prescription) prescriptions;
    }

    struct doctorRecord {
        address walletAddress;
        string name;
        string personalDetails;
        address hospitalAddress;
        Counters.Counter patientCount;
    }

    struct pharmacyRecord {
        string name;
        string personalDetails;
        address walletAddress;
    }

    struct hospitalRecord {
        string name;
        string hospitalDetails;
        address walletAddress;
        bytes32 customRoleDoctor;
        bytes32 customRolePatient;
        Counters.Counter patientInHospital;
        Counters.Counter doctorInHospital;
    }

    Counters.Counter patientCounter;
    Counters.Counter doctorCounter;
    Counters.Counter hospitalCounter;
    Counters.Counter pharmacyCounter;

    //: Constructor
    constructor() {
        _setRoleAdmin(HOSPITAL_ADMIN, HOSPITAL_ADMIN);
        _setRoleAdmin(DOCTOR, HOSPITAL_ADMIN);
        _setRoleAdmin(PATIENT, HOSPITAL_ADMIN);

        // default role of contract deployer
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function getRoleForUser(address _walletAddress)
        external
        view
        returns (string memory role)
    {
        if (hasRole(VERIFIED_PATIENT, _walletAddress)) {
            return "VERIFIED_PATIENT";
        } else if (hasRole(PATIENT, _walletAddress)) {
            return "PATIENT";
        } else if (hasRole(DEFAULT_ADMIN_ROLE, _walletAddress)) {
            return "DEFAULT_ADMIN_ROLE";
        } else if (hasRole(PHARMACY, _walletAddress)) {
            return "PHARMACY";
        } else {
            return "UNVERIFIED";
        }
    }

    function getRoleForDoctors(address _hospitalAddress, address _walletAddress)
        external
        view
        returns (string memory role)
    {
        if (
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _walletAddress
            )
        ) {
            return "ACCESS GRANTED BY HOSPITAL";
        } else if (hasRole(DOCTOR, _walletAddress)) {
            return "DOCTOR";
        } else {
            return "UNVERIFIED";
        }
    }

    //: PATIENT DATABASE
    mapping(address => patientRecord) patientDatabase;

    function setMedicalRecordByPatient(
        string memory _medicalRecordHash,
        address _walletAddress
    ) external returns (bool status) {
        if (hasRole(VERIFIED_PATIENT, _walletAddress)) {
            patientDatabase[_walletAddress].medicalRecordCount++;

            patientDatabase[_walletAddress]
                .medicalRecordCount = patientDatabase[_walletAddress]
                .medicalRecordCount;

            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .index = patientDatabase[_walletAddress].medicalRecordCount;
            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .patientRecordHash = _medicalRecordHash;
            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .verified = false;
        }

        return true;
    }

    function setMedicalRecordByDoctor(
        string memory _medicalRecordHash,
        address _walletAddress,
        address _hospitalAddress,
        address _doctorWalletAddress
    ) external returns (bool status) {
        if (
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _doctorWalletAddress
            )
        ) {
            patientDatabase[_walletAddress].medicalRecordCount++;

            patientDatabase[_walletAddress]
                .medicalRecordCount = patientDatabase[_walletAddress]
                .medicalRecordCount;

            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .index = patientDatabase[_walletAddress].medicalRecordCount;

            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .patientRecordHash = _medicalRecordHash;
            patientDatabase[_walletAddress]
                .medicalRecords[
                    patientDatabase[_walletAddress].medicalRecordCount
                ]
                .verified = true;
        }

        return true;
    }

    function setPrescriptionRecordByDoctor(
        string memory _prescriptionRecordHash,
        address _hospitalAddress,
        address _walletAddress,
        address _doctorWalletAddress
    ) external returns (bool status) {
        if (
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _doctorWalletAddress
            )
        ) {
            patientDatabase[_walletAddress].prescriptionCount++;

            patientDatabase[_walletAddress].prescriptionCount = patientDatabase[
                _walletAddress
            ].prescriptionCount;

            patientDatabase[_walletAddress]
                .prescriptions[
                    patientDatabase[_walletAddress].prescriptionCount
                ]
                .index = patientDatabase[_walletAddress].prescriptionCount;

            patientDatabase[_walletAddress]
                .prescriptions[
                    patientDatabase[_walletAddress].prescriptionCount
                ]
                .prescriptionHash = _prescriptionRecordHash;

            patientDatabase[_walletAddress]
                .prescriptions[
                    patientDatabase[_walletAddress].prescriptionCount
                ]
                .verified = true;
        }

        return true;
    }

    function getPrescriptions(address _walletAddress, uint256 _recordPosition)
        external
        view
        returns (Prescription memory value)
    {
        return (patientDatabase[_walletAddress].prescriptions[_recordPosition]);
    }

    function getPrescriptionsCountForPatient(address _walletAddress)
        external
        view
        returns (uint256 prescriptionsCountForPatient)
    {
        return (patientDatabase[_walletAddress].prescriptionCount);
    }

    function resetPrescriptionHash(
        uint256 index,
        address _patientWalletAddress,
        address _pharmacyWalletAddress,
        string memory _medicalRecordHash
    ) external returns (bool status) {
        if (hasRole(PHARMACY, _pharmacyWalletAddress)) {
            patientDatabase[_patientWalletAddress]
                .prescriptions[index]
                .prescriptionHash = _medicalRecordHash;
        }

        return true;
    }

    function updatedMedicalRecordHashByDoctor(
        uint256 index,
        address _patientWalletAddress,
        address _hospitalAddress,
        address _doctorWalletAddress,
        string memory _medicalRecordHash
    ) external returns (bool status) {
        if (
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _doctorWalletAddress
            )
        ) {
            patientDatabase[_patientWalletAddress]
                .medicalRecords[index]
                .patientRecordHash = _medicalRecordHash;
        }

        return true;
    }

    function setMedicalRecordVerificationStatus(
        uint256 index,
        address _patientWalletAddress,
        address _hospitalAddress,
        address _doctorWalletAddress,
        bool _verified
    ) external returns (bool status) {
        if (
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _doctorWalletAddress
            )
        ) {
            patientDatabase[_patientWalletAddress]
                .medicalRecords[index]
                .verified = _verified;
        }

        return true;
    }

    function getMedicalRecord(address _walletAddress, uint256 _recordPosition)
        external
        view
        returns (MedicalRecord memory value)
    {
        return (
            patientDatabase[_walletAddress].medicalRecords[_recordPosition]
        );
    }

    function getMedicalRecordCountForPatient(address _walletAddress)
        external
        view
        returns (uint256 medicalRecordCount)
    {
        return (patientDatabase[_walletAddress].medicalRecordCount);
    }

    function updatePatientPersonalDetailHash(
        string memory _personalDetails,
        address _walletAddress
    ) external returns (bool status) {
        if (
            hasRole(PATIENT, _walletAddress) ||
            hasRole(VERIFIED_PATIENT, _walletAddress)
        ) {
            patientDatabase[_walletAddress].personalDetails = _personalDetails;
        }

        return true;
    }

    function storePatient(
        string memory _name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _doctorAddress,
        address _walletAddress
    ) external returns (bool status) {
        if (
            hasRole(PATIENT, _walletAddress) ||
            hasRole(VERIFIED_PATIENT, _walletAddress)
        ) {
            patientDatabase[_walletAddress].name = _name;
            this.updatePatientPersonalDetailHash(
                _personalDetails,
                _walletAddress
            );
        } else {
            _setupRole(PATIENT, _walletAddress);
            patientDatabase[_walletAddress].name = _name;
            patientDatabase[_walletAddress].personalDetails = _personalDetails;
            patientDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
            patientDatabase[_walletAddress].walletAddress = _walletAddress;
            patientDatabase[_walletAddress].doctorAddress = _doctorAddress;

            doctorDatabase[_doctorAddress].patientCount.increment();

            hospitalDatabase[_hospitalAddress].patientInHospital.increment();
            patientCounter.increment();
        }

        return true;
    }

    function changeHospitalForPatient(
        address _previousHospitalAddress,
        address _newHospitalAddress,
        address _walletAddress
    ) external returns (bool status) {
        if (hasRole(VERIFIED_PATIENT, _walletAddress)) {
            hospitalDatabase[_previousHospitalAddress]
                .patientInHospital
                .decrement();

            patientDatabase[_walletAddress]
                .hospitalAddress = _newHospitalAddress;

            hospitalDatabase[_newHospitalAddress].patientInHospital.increment();
            return true;
        }
    }

    function changeDoctorForPatient(
        address _previousDoctorAddress,
        address _newDoctorAddress,
        address _walletAddress
    ) external returns (bool status) {
        if (hasRole(VERIFIED_PATIENT, _walletAddress)) {
            doctorDatabase[_previousDoctorAddress].patientCount.decrement();

            patientDatabase[_walletAddress].doctorAddress = _newDoctorAddress;

            doctorDatabase[_newDoctorAddress].patientCount.increment();
            return true;
        }
    }

    function retrievePatientCount()
        external
        view
        returns (uint256 patientCount)
    {
        return patientCounter.current();
    }

    function retrievePatientData(address _walletAddress)
        external
        view
        returns (
            string memory name,
            string memory personalDetails,
            address hospitalAddress,
            address walletAddress
        )
    {
        return (
            patientDatabase[_walletAddress].name,
            patientDatabase[_walletAddress].personalDetails,
            patientDatabase[_walletAddress].hospitalAddress,
            _walletAddress
        );
    }

    //: DOCTOR DATABASE
    mapping(address => doctorRecord) doctorDatabase;

    function storeDoctor(
        string memory name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _walletAddress
    ) external returns (bool status) {
        if (
            hasRole(DOCTOR, _walletAddress) ||
            hasRole(
                hospitalDatabase[_hospitalAddress].customRoleDoctor,
                _walletAddress
            )
        ) {
            this.updateDoctorPersonalDetailHash(
                _personalDetails,
                _walletAddress
            );
        } else {
            _setupRole(DOCTOR, _walletAddress);
            doctorDatabase[_walletAddress].name = name;
            doctorDatabase[_walletAddress].walletAddress = _walletAddress;
            doctorDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
            doctorDatabase[_walletAddress].personalDetails = _personalDetails;

            hospitalDatabase[_hospitalAddress].doctorInHospital.increment();
            doctorCounter.increment();
        }

        return true;
    }

    function updateDoctorPersonalDetailHash(
        string memory _personalDetails,
        address _walletAddress
    ) external returns (bool status) {
        doctorDatabase[_walletAddress].personalDetails = _personalDetails;
        return true;
    }

    function changeHospitalForDoctor(
        address _previousHospitalAddress,
        address _newHospitalAddress,
        address _walletAddress
    ) external returns (bool status) {
        if (
            hasRole(
                hospitalDatabase[_previousHospitalAddress].customRoleDoctor,
                _walletAddress
            )
        ) {
            hospitalDatabase[_previousHospitalAddress]
                .doctorInHospital
                .decrement();
            doctorDatabase[_walletAddress]
                .hospitalAddress = _newHospitalAddress;
            hospitalDatabase[_newHospitalAddress].doctorInHospital.increment();
            return true;
        } else {
            return false;
        }
    }

    function retrieveDoctorCount() external view returns (uint256 doctorCount) {
        return doctorCounter.current();
    }

    function getDoctorData(address _doctorAddress)
        public
        view
        returns (
            string memory name,
            string memory doctorDetails,
            address walletAddress,
            uint256 patientCount,
            address hospitalAddress
        )
    {
        return (
            doctorDatabase[_doctorAddress].name,
            doctorDatabase[_doctorAddress].personalDetails,
            _doctorAddress,
            doctorDatabase[_doctorAddress].patientCount.current(),
            doctorDatabase[_doctorAddress].hospitalAddress
        );
    }

    //: Pharmacy DATABASE
    mapping(address => pharmacyRecord) pharmacyDatabase;

    function storePharmacy(
        string memory name,
        string memory _personalDetails,
        address _walletAddress
    ) external returns (bool status) {
        if (hasRole(PHARMACY, _walletAddress)) {
            this.updatePharmacyPersonalDetailHash(
                _personalDetails,
                _walletAddress
            );
        } else {
            _setupRole(PHARMACY, _walletAddress);
            pharmacyDatabase[_walletAddress].name = name;
            pharmacyDatabase[_walletAddress].walletAddress = _walletAddress;
            pharmacyDatabase[_walletAddress].personalDetails = _personalDetails;
            pharmacyCounter.increment();
        }

        return true;
    }

    function updatePharmacyPersonalDetailHash(
        string memory _personalDetails,
        address _walletAddress
    ) external returns (bool status) {
        require(hasRole(PHARMACY, _walletAddress));
        pharmacyDatabase[_walletAddress].personalDetails = _personalDetails;
        return true;
    }

    function retrievePharmacyCount()
        external
        view
        returns (uint256 pharmacyCount)
    {
        return pharmacyCounter.current();
    }

    function getPharmacyData(address _walletAddress)
        public
        view
        returns (
            string memory name,
            string memory pharmacyDetails,
            address walletAddress
        )
    {
        require(hasRole(PHARMACY, _walletAddress));

        return (
            pharmacyDatabase[_walletAddress].name,
            pharmacyDatabase[_walletAddress].personalDetails,
            _walletAddress
        );
    }

    //: HOSPITAL DATABASE
    mapping(address => hospitalRecord) hospitalDatabase;

    function storeHospital(
        string memory _name,
        string memory _hospitalDetails,
        address _walletAddress,
        string memory _customRole
    ) external returns (bool status) {
        bytes32 customRole = this.convertRoleFromStringToBytes(_customRole);
        if (hasRole(DEFAULT_ADMIN_ROLE, _walletAddress)) {
            this.updateHospitalPersonalDetailHash(
                _hospitalDetails,
                _walletAddress,
                customRole
            );
        } else {
            _setupRole(DEFAULT_ADMIN_ROLE, _walletAddress);
            hospitalDatabase[_walletAddress].name = _name;
            hospitalDatabase[_walletAddress].walletAddress = _walletAddress;
            hospitalDatabase[_walletAddress].hospitalDetails = _hospitalDetails;
            hospitalDatabase[_walletAddress].customRoleDoctor = customRole;
            hospitalCounter.increment();
        }

        return true;
    }

    function grantRoleFromHospital(
        address hospitalAddress,
        address _walletAddress,
        string memory _customRole
    ) external returns (bool status) {
        if (hasRole(DEFAULT_ADMIN_ROLE, hospitalAddress)) {
            bytes32 customRole = this.convertRoleFromStringToBytes(_customRole);
            grantRole(customRole, _walletAddress);
        } else {
            return false;
        }
        return true;
    }

    function revokeRoleFromHospital(
        address hospitalAddress,
        address _walletAddress,
        string memory _customRole
    ) external returns (bool status) {
        bytes32 customRole = this.convertRoleFromStringToBytes(_customRole);
        if (hasRole(DEFAULT_ADMIN_ROLE, hospitalAddress)) {
            revokeRole(customRole, _walletAddress);
        } else {
            return false;
        }
        return true;
    }

    //updated function
    function updateHospitalPersonalDetailHash(
        string memory _personalDetails,
        address _walletAddress,
        bytes32 _customRole
    ) external returns (bool status) {
        patientDatabase[_walletAddress].personalDetails = _personalDetails;
        hospitalDatabase[_walletAddress].customRoleDoctor = _customRole;

        return true;
    }

    function retrieveHospitalCount()
        external
        view
        returns (uint256 hospitalCount)
    {
        return hospitalCounter.current();
    }

    function retrieveHospitalSpecificCountOfDoctors(address _hospitalAddress)
        external
        view
        returns (uint256 doctorCountInHospital)
    {
        return hospitalDatabase[_hospitalAddress].doctorInHospital.current();
    }

    function retrieveHospitalSpecificCountOfPatients(address _hospitalAddress)
        external
        view
        returns (uint256 patientCountInHospital)
    {
        return hospitalDatabase[_hospitalAddress].patientInHospital.current();
    }

    function getHospitalData(address _hospitalAddress)
        public
        view
        returns (
            string memory nameAdmin,
            string memory hospitalDetails,
            address walletAddress,
            uint256 doctorCountInHospital,
            uint256 patientCountInHospital
        )
    {
        return (
            hospitalDatabase[_hospitalAddress].name,
            hospitalDatabase[_hospitalAddress].hospitalDetails,
            hospitalDatabase[_hospitalAddress].walletAddress,
            hospitalDatabase[_hospitalAddress].doctorInHospital.current(),
            hospitalDatabase[_hospitalAddress].patientInHospital.current()
        );
    }

    function retrieveCountForEntities()
        external
        view
        returns (
            uint256 patientCount,
            uint256 doctorCount,
            uint256 hospitalCount,
            uint256 pharmacyCount
        )
    {
        return (
            patientCounter.current(),
            doctorCounter.current(),
            hospitalCounter.current(),
            pharmacyCounter.current()
        );
    }

    function convertRoleFromStringToBytes(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }
}
