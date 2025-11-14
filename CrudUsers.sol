// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

contract CRUDUsers{

    struct User{
        uint256 id;
        string name;
        uint age;
    }
    User[] public users;
    uint256 public nextId = 1;

    //Create User
    function createUser(string memory _name , uint256 _age) public {
        users.push(User(nextId,_name,_age));
        nextId++;
    }

    //get user by id
    function getUser(uint256 _id) public view returns(uint256 , string memory , uint256) {
        for(uint256 i = 0 ; i < users.length ; i++ ){
            if(users[i].id == _id){
                return (users[i].id , users[i].name , users[i].age);
            }
        }
        revert("User not found");
    }
    //get all users
    function getAllUsers() public view returns(User[] memory){
       return users;
    }


    //Update user by id
    function updateUser(uint256 _id , string memory _name , uint256 _age) public {
        for(uint256 i = 0 ; i < users.length ; i++ ){
            if(users[i].id == _id){
                users[i].name = _name;
                users[i].age = _age;
                return;
            }
        }
    }

    //Delete user by id
    function deleteUser(uint256 _id) public {
        for(uint256 i = 0 ; i < users.length ; i++ ){
            if(users[i].id == _id){
                users[i] = users[users.length-1];
                users.pop();
                return;
            }
        }
        revert("User not found");
    }
}