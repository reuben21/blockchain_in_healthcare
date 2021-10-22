// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HospitalToken is ERC20 {
    constructor() ERC20("HospitalToken", "HTK") {
        _mint(msg.sender, 1000000000000);
    }

    function getEthBalance(address _addr) external view returns (uint256) {
        return _addr.balance;
    }
}
