pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT
import "./access/AccessControlEnumerable.sol";
import "./Roles.sol";

contract Pharmacy is AccessControl {
    struct pharmacyRecord {
        string name;
        string personalDetails;
        address walletAddress;
    }

    event LogPharmacy(string name, string personalDetails, address owner);

    //: Pharmacy DATABASE
    mapping(address => pharmacyRecord) pharmacyDatabase;

    function registerPharmacy(
        string memory name,
        string memory _personalDetails,
        address _walletAddress
    ) external returns (string memory status) {
        _setupRole(PHARMACY, _walletAddress);
        pharmacyDatabase[_walletAddress].name = name;
        pharmacyDatabase[_walletAddress].walletAddress = _walletAddress;
        pharmacyDatabase[_walletAddress].personalDetails = _personalDetails;

        emit LogPharmacy(
            pharmacyDatabase[_walletAddress].name,
            pharmacyDatabase[_walletAddress].personalDetails,
            _walletAddress
        );

        return "PHARMACY_REGISTERED";
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
        return (
            pharmacyDatabase[_walletAddress].name,
            pharmacyDatabase[_walletAddress].personalDetails,
            _walletAddress
        );
    }
}
