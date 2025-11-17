// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Calculator{

    uint256 result = 0;
    function add(uint256 number) public{
        result += number;
    }

    function sub(uint256 number) public{
        result -= number;
    }
    function multiply(uint256 number) public{
        result *= number;
    }
    // function div(uint256 number) public{
    //     result /= number;
    // }
    function get() public view returns(uint256) {
        return result;
    }
}