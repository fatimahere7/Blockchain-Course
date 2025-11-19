// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyContract{
    event addedData();
    event deletedData();
    struct MyData{
        uint256 id;
        string fname;
        string lname;
        uint256 age;
        string designation;
        string homeAddress;
    }
    mapping(address => MyData[]) mine;
    function addNewData() public {

        emit addedData();
    }
    function deleteData() public {

        emit deletedData();
    }
    modifier onlyOwner(){

        _;
    }

}