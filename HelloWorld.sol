// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract HelloWorld{
    string public greet = "Hello , Ethereum";

    function setGreet(string memory _newGreet) public {
        greet = _newGreet;
    }

    function getGreet() public view returns(string memory) {
        return greet;
    }
}