pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT
import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";

contract Hospital is AccessControl {
    //  bytes32 constant DOCTOR = keccak256("DOCTOR");

    struct hospitalRecord {
        string name;
        string hospitalDetails;
        address walletAddress;
    }

    event LogHospital(string name, address walletAddress, address owner);
    event LogUpdateHospital(string name, string dateOfBirth);
    event LogDeleteHospital(string name, uint256 empIdIndex);

    //: HOSPITAL DATABASE
    mapping(address => hospitalRecord) hospitalDatabase;

    function registerHospital(
        string memory _name,
        string memory _hospitalDetails,
        address walletAddress
    ) external returns (string memory status) {
        _setupRole(HOSPITAL_ADMIN, walletAddress);
        hospitalDatabase[walletAddress].name = _name;
        hospitalDatabase[walletAddress].walletAddress = walletAddress;
        hospitalDatabase[walletAddress].hospitalDetails = _hospitalDetails;

        return "HOSPITAL";
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
