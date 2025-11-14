// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage{
    //Basic Types : boolean , uint , int , address , bytes
    uint256 public number; //we see the variable value by using public
    
    //function to store a number
    function setNumber(uint256 _num) public {
        number = _num;
    }
    
    //view , pure
    //function to reterieve thr number
    function retrieve() public view returns (uint256){
        return number;
    }
}