pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "./access/AccessControlEnumerable.sol";

//: Creating the Roles
bytes32 constant PATIENT = keccak256("PATIENT");
bytes32 constant VERIFIED_PATIENT = keccak256("VERIFIED_PATIENT");

bytes32 constant DOCTOR = keccak256("DOCTOR");
bytes32 constant VERIFIED_DOCTOR = keccak256("VERIFIED_DOCTOR");

bytes32 constant PHARMACY = keccak256("PHARMACY");

bytes32 constant HOSPITAL_ADMIN = keccak256("HOSPITAL_ADMIN");
