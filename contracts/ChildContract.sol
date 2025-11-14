// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ChildContract{
    uint256 public number;

    constructor(uint256 _number){
        number = _number;
    }
}