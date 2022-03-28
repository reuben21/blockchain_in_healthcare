// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./openzeppelin/contracts/access/AccessControl.sol";

contract HospitalToken is ERC20 {
    constructor() ERC20("HospitalToken", "HPT") {
        _mint(msg.sender, 10000000);
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function mintForUser(address _walletAddress, uint256 amount) public {
        _mint(_walletAddress, amount);
    }
}
