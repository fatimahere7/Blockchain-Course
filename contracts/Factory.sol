// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./ChildContract.sol";

contract FatoryContract{
    ChildContract[] public deployedContarct;
    function createChild(uint256 _num) public{
        ChildContract child = new ChildContract(_num);
        deployedContarct.push(child);
    }
    function getChild() public view returns(ChildContract[] memory){
        return deployedContarct;
    }
}