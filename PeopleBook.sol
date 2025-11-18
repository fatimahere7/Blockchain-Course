// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PeopleBook{
    struct Person{
        string name;
        uint256 age;
    }
    Person[] public persons;
    mapping(string => uint256) public nameToAge;
    
    function addPerson(string memory _name, uint256 _age) public {
        persons.push(Person(_name,_age));
    }
    function getPersons() public view returns(Person[] memory){
        return persons;
    }
    function updateAge(string memory _name,uint256 _newAge) public {
        for(uint i = 0; i< persons.length ; i++){
            if(keccak256(bytes(persons[i].name)) == keccak256(bytes(_name))){
                persons[i].age = _newAge;
            }
        }
        nameToAge[_name] = _newAge;
    }
}