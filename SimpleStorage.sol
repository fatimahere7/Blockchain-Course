// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SimpleStorage{
    //Basic Types : boolean , uint , int , address , bytes
    uint256 public favNum; //we see the variable value by using public
    uint256[] listOfNumber;  
    function store(uint256 _favNum) public {
        favNum = _favNum;
    }

    //view , pure
    function retrieve() public view returns (uint256){
        return favNum;
    }
}