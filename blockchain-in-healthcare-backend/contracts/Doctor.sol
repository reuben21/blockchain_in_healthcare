pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";
import "./Patient.sol";

contract Doctor is AccessControl {
    struct doctorRecord {
        string name;
        string personalDetails;
        address hospitalAddress;
        address walletAddress;
    }

    event LogDoctor(string name, string personalDetails, address owner);
    event LogUpdateDoctor(string name, string personalDetails);
    event LogDeleteDoctor(string name, uint256 empIdIndex);

    //: DOCTOR DATABASE
    mapping(address => doctorRecord) doctorDatabase;

    function registerDoctor(
        string memory name,
        string memory _personalDetails,
        address _hospitalAddress,
        address _walletAddress
    ) external returns (string memory status) {
        _setupRole(DOCTOR, _walletAddress);
        doctorDatabase[_walletAddress].name = name;
        doctorDatabase[_walletAddress].walletAddress = _walletAddress;
        doctorDatabase[_walletAddress].hospitalAddress = _hospitalAddress;
        doctorDatabase[_walletAddress].personalDetails = _personalDetails;

        emit LogDoctor(
            doctorDatabase[_walletAddress].name,
            doctorDatabase[_walletAddress].personalDetails,
            _walletAddress
        );

        return "DOCTOR_REGISTERED_SUCCESSFULLY";
    }

    function getDoctorData(
        address _walletAddress,
        address _addressOfHigherAuthority
    )
        public
        view
        returns (
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
}
