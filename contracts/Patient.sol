pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";

contract Patient is AccessControl {
    struct patientRecord {
        string name;
        string personalDetails;
        string signatureHash;
        address hospitalAddress;
        address walletAddress;
        string[] previousPatientRecordHashes;
        string newMedicalRecordHash;
        string[] previousPatientPrescriptionHashes;
        string newPatientPrescriptionHashes;
    }

    event LogPatient(string name, address hospitalAddress, address owner);
    event LogUpdatePatientDOB(string name, string dateOfBirth);
    event LogDeleteEmp(string name, uint256 empIdIndex);

    //: PATIENT DATABASE
    mapping(address => patientRecord) patientDatabase;

    function registerPatient(
        string memory _name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _walletAddress,
        string memory _signatureHash
    ) external returns (string memory status) {
        _setupRole(PATIENT, _walletAddress);
        patientDatabase[_walletAddress].name = _name;
        patientDatabase[_walletAddress].personalDetails = _personalDetails;
        patientDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
        patientDatabase[_walletAddress].walletAddress = _walletAddress;
        patientDatabase[_walletAddress].signatureHash = _signatureHash;

        // emit LogPatient(
        //     patientDatabase[_walletAddress].name,
        //     patientDatabase[_walletAddress].hospitalAddress,
        //     _walletAddress
        // );

        return "PATIENT REGISTERED";
    }

    function getSignatureHash() public view returns (string memory) {
        require(
            msg.sender == patientDatabase[msg.sender].walletAddress,
            "Not allowed"
        );

        return patientDatabase[msg.sender].signatureHash;
    }

    function getUserAddress() public view returns (address) {
        return patientDatabase[msg.sender].walletAddress;
    }

    function getPatientData(address _walletAddress)
        external
        view
        returns (
            string memory name,
            string memory personalDetails,
            address walletAddress
        )
    {
        return (
            patientDatabase[_walletAddress].name,
            patientDatabase[_walletAddress].personalDetails,
            _walletAddress
        );
    }

    function updatePatientPersonalData(
        address _walletAddress,
        string memory _personalDetails
    ) public returns (bool success) {
        patientDatabase[_walletAddress].personalDetails = _personalDetails;

        emit LogUpdatePatientDOB(
            patientDatabase[_walletAddress].name,
            patientDatabase[_walletAddress].personalDetails
        );

        return true;
    }

    function updatePatientMedicalRecords(
        address _walletAddress,
        string memory medicalRecordHash
    ) external returns (string memory status) {
        if (
            keccak256(
                abi.encodePacked(
                    patientDatabase[_walletAddress].newMedicalRecordHash
                )
            ) == keccak256(abi.encodePacked(""))
        ) {
            patientDatabase[_walletAddress]
                .newMedicalRecordHash = medicalRecordHash;
            return "ENTERED ONCE RECORD ONLY";
        } else {
            patientDatabase[_walletAddress].previousPatientRecordHashes.push(
                patientDatabase[_walletAddress].newMedicalRecordHash
            );
            patientDatabase[_walletAddress]
                .newMedicalRecordHash = medicalRecordHash;
            return "ENTERED TWICE RECORD ONLY";
        }
    }

    function updatePatientPrescription(
        address _walletAddress,
        string memory prescriptionHash
    ) external returns (string memory status) {
        if (
            keccak256(
                abi.encodePacked(
                    patientDatabase[_walletAddress].newPatientPrescriptionHashes
                )
            ) == keccak256(abi.encodePacked(""))
        ) {
            patientDatabase[_walletAddress]
                .newPatientPrescriptionHashes = prescriptionHash;
            return "ENTERED ONCE PRESCRIPTION ONLY";
        } else {
            patientDatabase[_walletAddress]
                .previousPatientPrescriptionHashes
                .push(
                    patientDatabase[_walletAddress].newPatientPrescriptionHashes
                );
            patientDatabase[_walletAddress]
                .newPatientPrescriptionHashes = prescriptionHash;
            return "ENTERED TWICE PRESCRIPTION ONLY";
        }
    }

    function getNewPrescription(address _patientAddress)
        external
        view
        returns (string memory status)
    {
        return patientDatabase[_patientAddress].newPatientPrescriptionHashes;
    }

    function getMultiplePrescription(address _patientAddress)
        external
        view
        returns (string[] memory status)
    {
        return
            patientDatabase[_patientAddress].previousPatientPrescriptionHashes;
    }

    function getNewRecords(address _patientAddress)
        external
        view
        returns (string memory status)
    {
        return patientDatabase[_patientAddress].newMedicalRecordHash;
    }

    function getMultipleRecords(address _patientAddress)
        external
        view
        returns (string[] memory status)
    {
        return patientDatabase[_patientAddress].previousPatientRecordHashes;
    }
}
