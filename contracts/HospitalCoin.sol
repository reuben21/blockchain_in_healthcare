// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HospitalCoin is ERC20 {
    constructor() ERC20("HospitalCoin", "HTK") {
        _mint(msg.sender, 10000);
    }

    function getEthBalance(address _addr) external view returns (uint256) {
        return _addr.balance;
    }
}
