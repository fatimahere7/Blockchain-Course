// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract ArraysAndStruct{

    uint256 public myfavNum; //we see the variable value by using public

    struct Person {
        uint256 favNum;
        string name;
    }

    //dynamic array [] ,static array [3]
    Person[] public listOfPersons;
    
    
    function store(uint256 _favNum) public {
        myfavNum = _favNum;
    }

    //view , pure
    function retrieve() public view returns (uint256){
        return myfavNum;
    }

    function addPerson(string memory _name, uint256 _favNum) public {
        listOfPersons.push(Person(_favNum , _name));
    }

}