// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyToken{
    // planning the token

    string public name = "FatiCoin";
    string public symb = "FATI";
    uint8 public decimals = 18;

    //total supply : how many tokens exists
    uint public totalSupply;  

    //balances :
    mapping(address => uint256) balancesOf;
    //allowance:
    // allowance[owner][spender] = amount allowed to spend
    mapping(address => mapping (address => uint256)) allowance;
    
    event transferEvent(address indexed from , address indexed to , uint256 amount);
    event approvalEvent(address indexed owner, address indexed sender , uint256 amount);
     
    constructor(uint256 _initialSupply){
        totalSupply = _initialSupply * (10 ** decimals);
        balancesOf[msg.sender] = totalSupply;
        emit transferEvent(address(0), msg.sender, totalSupply);
    } 
    

    //Transfer tokens:
    function transfer(address _to , uint256 _amount) public returns(bool) {
        uint256 balance = balancesOf[msg.sender];
        require(balance >= _amount,"Not enough balance");
        balancesOf[msg.sender] -= _amount;
        balancesOf[_to] += _amount;
        emit transferEvent(msg.sender, _to , _amount);
        return true;
    }

    //Approve someone to use tokens:
    function approve(address _sender, uint256 _amount) public returns (bool){
        require(_sender != address(0) , "Invalid Sender");
        allowance[msg.sender][_sender] = _amount;
        emit approvalEvent(msg.sender, _sender, _amount);
        return true;
    }

    //Transfer tokens using allowance
    function transferForm(address _from , address _to , uint256 _amount) public returns (bool){
        require(_to != address(0) , "Invalid Sender");
        require(balancesOf[_from] >= _amount , "Not enough tokens");
        require(allowance[_from][msg.sender] >= _amount , "allowance too low");

        balancesOf[_from] -= _amount;
        balancesOf[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;
        emit transferEvent(_from, _to, _amount);
        return true;
    }

    // function burnOrIncreaseSupply() {}
}