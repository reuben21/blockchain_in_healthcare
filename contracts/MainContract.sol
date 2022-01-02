pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT
import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

struct patientRecord {
        string name;
        string personalDetails;
        address hospitalAddress;
        address walletAddress;
        string[] previousPatientRecordHashes;
        string newMedicalRecordHash;
        string[] previousPatientPrescriptionHashes;
        string newPatientPrescriptionHashes;
    }

struct doctorRecord {
        string name;
        string personalDetails;
        address hospitalAddress;
        address walletAddress;
    }

struct pharmacyRecord {
        string name;
        string personalDetails;
        address walletAddress;
    }




contract MainContract is AccessControl {
    using Counters for Counters.Counter;

    struct hospitalRecord {
        string name;
        string hospitalDetails;
        address walletAddress;
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

    event LogStorePatient( string name, address hospitalAddress,  string _personalDetails,  address owner);
    event LogUpdatePatientPersonalDetails(string name, string _personalDetails);


    //: PATIENT DATABASE
    mapping(address => patientRecord) patientDatabase;

    function storePatient(
        string memory _name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _walletAddress
  
    ) external returns (bool status) {
        if (hasRole(PATIENT, _walletAddress)) {

        patientDatabase[_walletAddress].name = _name;
        patientDatabase[_walletAddress].personalDetails = _personalDetails;
        patientDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
        patientDatabase[_walletAddress].walletAddress = _walletAddress;
        

        } else {
            _setupRole(PATIENT, _walletAddress);
   
        patientDatabase[_walletAddress].name = _name;
        patientDatabase[_walletAddress].personalDetails = _personalDetails;
        patientDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
        patientDatabase[_walletAddress].walletAddress = _walletAddress;
        hospitalDatabase[_hospitalAddress].patientInHospital.increment();
        patientCounter.increment();

        }
        
        emit LogStorePatient(
            patientDatabase[_walletAddress].name,
            patientDatabase[_walletAddress].hospitalAddress,
            patientDatabase[_walletAddress].personalDetails,
            _walletAddress
        );

        return true;
    }

    function retrievePatientCount() external view returns (uint256 patientCount) {
        return patientCounter.current();
    }

  
 
    function retrievePatientData(address _walletAddress)
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

        emit LogUpdatePatientPersonalDetails(
            patientDatabase[_walletAddress].name,
            patientDatabase[_walletAddress].personalDetails
        );

        return true;
    }

    function updatePatientMedicalRecords(
        address _walletAddress,
        string memory medicalRecordHash
    ) external returns (bool status) {
        if (
            keccak256(
                abi.encodePacked(
                    patientDatabase[_walletAddress].newMedicalRecordHash
                )
            ) == keccak256(abi.encodePacked(""))
        ) {
            patientDatabase[_walletAddress]
                .newMedicalRecordHash = medicalRecordHash;
            return true;
        } else {
            patientDatabase[_walletAddress].previousPatientRecordHashes.push(
                patientDatabase[_walletAddress].newMedicalRecordHash
            );
            patientDatabase[_walletAddress]
                .newMedicalRecordHash = medicalRecordHash;
            return true;
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

    function getNewRecords(address _patientAddress) external view returns (string memory status)
    {
        return patientDatabase[_patientAddress].newMedicalRecordHash;
    }

    function getMultipleRecords(address _patientAddress) external view returns (string[] memory status)
    {
        return patientDatabase[_patientAddress].previousPatientRecordHashes;
    }


    event LogStoreDoctor(string name, string personalDetails, address owner);
    event LogUpdateDoctor(string name, string personalDetails);
    event LogDeleteDoctor(string name, uint256 empIdIndex);

    //: DOCTOR DATABASE
    mapping(address => doctorRecord) doctorDatabase;

    function storeDoctor(
        string memory name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _walletAddress
    ) external returns (bool status) {
        _setupRole(DOCTOR, _walletAddress);
        doctorDatabase[_walletAddress].name = name;
        doctorDatabase[_walletAddress].walletAddress = _walletAddress;
        doctorDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
        doctorDatabase[_walletAddress].personalDetails = _personalDetails;
        hospitalDatabase[_hospitalAddress].doctorInHospital.increment();
        doctorCounter.increment();

        emit LogStoreDoctor(
            doctorDatabase[_walletAddress].name,
            doctorDatabase[_walletAddress].personalDetails,
            _walletAddress
        );

        return true;
    }

    function retrieveDoctorCount() external view returns (uint256 doctorCount) {
        return doctorCounter.current();
    }

    function retrieveDoctorData( address _walletAddress) public view returns (
            string memory name,
            string memory personalDetails,
            address hospitalAddress
        )
    {
        return (
            doctorDatabase[_walletAddress].name,
            doctorDatabase[_walletAddress].personalDetails,
            doctorDatabase[_walletAddress].hospitalAddress
        );
    }

    event LogPharmacy(string name, string personalDetails, address owner);

    //: Pharmacy DATABASE
    mapping(address => pharmacyRecord) pharmacyDatabase;

    function storePharmacy(
        string memory name,
        string memory _personalDetails,
        address _walletAddress
    ) external returns (bool status) {
        _setupRole(PHARMACY, _walletAddress);
        pharmacyDatabase[_walletAddress].name = name;
        pharmacyDatabase[_walletAddress].walletAddress = _walletAddress;
        pharmacyDatabase[_walletAddress].personalDetails = _personalDetails;
        pharmacyCounter.increment();
        emit LogPharmacy(
            pharmacyDatabase[_walletAddress].name,
            pharmacyDatabase[_walletAddress].personalDetails,
            _walletAddress
        );

        return true;
    }

    function retrievePharmacyCount() external view returns (uint256 pharmacyCount) {
        return pharmacyCounter.current();
    }

    function getPharmacyData(address _walletAddress)   public  view  returns (
            string memory name,
            string memory pharmacyDetails,
            address walletAddress
        )
    {
        return (
            pharmacyDatabase[_walletAddress].name,
            pharmacyDatabase[_walletAddress].personalDetails,
            _walletAddress
        );
    }



    event LogHospital(string name,string _hospitalDetails, address walletAddress);
    event LogUpdateHospital(string name, string dateOfBirth);
    event LogDeleteHospital(string name, uint256 empIdIndex);

    //: HOSPITAL DATABASE
    mapping(address => hospitalRecord) hospitalDatabase;

    function storeHospital(
        string memory _name,
        string memory _hospitalDetails,
        address _walletAddress
    ) external returns (bool status) {
        _setupRole(HOSPITAL_ADMIN, _walletAddress);
        hospitalDatabase[_walletAddress].name = _name;
        hospitalDatabase[_walletAddress].walletAddress = _walletAddress;
        hospitalDatabase[_walletAddress].hospitalDetails = _hospitalDetails;
        hospitalCounter.increment();

        emit LogHospital(_name, _hospitalDetails, _walletAddress);

        return true;
    }

    function retrieveHospitalCount() external view returns (uint256 hospitalCount) {
        return hospitalCounter.current();
    }

    function retrieveHospitalSpecificCountOfDoctors(address _hospitalAddress) external view returns (uint256 doctorCountInHospital) {
        return hospitalDatabase[_hospitalAddress].doctorInHospital.current();
    }

    function retrieveHospitalSpecificCountOfPatients(address _hospitalAddress) external view returns (uint256 patientCountInHospital) {
        return hospitalDatabase[_hospitalAddress].patientInHospital.current();
    }

    function getHospitalData(address addressOfUser)
        public
        view
        returns (
            string memory _nameAdmin,
            string memory hospitalDetails,
            address walletAddress
        )
    {
        return (
            hospitalDatabase[addressOfUser].name,
            hospitalDatabase[addressOfUser].hospitalDetails,
            hospitalDatabase[addressOfUser].walletAddress
        );
    }

}