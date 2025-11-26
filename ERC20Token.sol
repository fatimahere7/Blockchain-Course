// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20Token is ERC20, ERC20Pausable, Ownable {
    uint256 public tax;
    address public taxWallet;
    uint256 public totalTax;
    address public admin;
    mapping (address => bool) public exemptedFromTax;
    bool public isTaxPaused = true;
    bool public senderTaxPaused = true;
    bool public receiverTaxPaused = true;
    uint256 private totalBalance = 10000000 * 10 ** decimals();
    mapping(address => uint256)public accountToAmountBalances;
    constructor(address recipient , uint256 taxPercent, address _taxWallet)
        ERC20("MyToken", "MTK")
        Ownable(msg.sender)
    {
        _mint(recipient, totalBalance);
        accountToAmountBalances[recipient] = totalBalance;
        tax = taxPercent * 100;
        taxWallet = _taxWallet;


    }
    function setAdmin(address _admin) public onlyOwner{
        admin = _admin;
    }
    modifier onlyAdmin(){
        require(msg.sender == admin ,"Only Admin can access this");
        _;
    }
    function taxUpdated(uint256 _tax) public onlyAdmin{
        tax = _tax*100;
    }
    function addExemptedAddress(address addr) public onlyAdmin{
        exemptedFromTax[addr] = true;
    }
    function updateTaxWallet(address updatedWallet) public onlyOwner{
        taxWallet = updatedWallet;
    }

    function _transferVal(address from, address to, uint256 value) internal returns (bool){
        if(accountToAmountBalances[from] < value){
            revert("Not enough Balance");

        }else{
            accountToAmountBalances[from] -= value;
            accountToAmountBalances[to] += value;
            return true;
        }
    }


    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        bool success;
        
        if(exemptedFromTax[recipient]){
            success =_transferVal(msg.sender,recipient, amount);
            return success;
        }
        if(isTaxPaused){
            success =_transferVal(msg.sender,recipient, amount);
            return success;
        }else{

        uint256 taxCalulated = ((amount * tax) / 10000);
        uint256 totalAmount = amount + taxCalulated;  
        uint256 amountToTransfer = amount - taxCalulated;
        uint256 taxFromSender = totalAmount - amount;
        
        
        
        if(!senderTaxPaused){
            
            success = _transferVal(msg.sender,recipient, amountToTransfer);
            require(success , "Tranfer failed");
            // updateTaxWallet(taxCalculates) 
            success = super.transfer(taxWallet, taxCalulated);
            require(success , "Tax didnt send");
            return true;
        }else if(!receiverTaxPaused){
            success = super.transfer(taxWallet, taxFromSender);
            require(success , "Tax from sender failed");
            return success;
        }else{
            success = _transferVal(msg.sender,recipient, amount); 
            require(success, "Didnt send Amount" );
            return success;
        }
        
      }
    }
    function taxPaused() public onlyOwner{
        isTaxPaused = !isTaxPaused;
    }
    function isSenderTaxPaused() public onlyOwner{
        senderTaxPaused = !senderTaxPaused;
    }
    function isReceiverTaxPaused() public onlyOwner{
        receiverTaxPaused = !receiverTaxPaused;
    }
    // function transferFrom(address receiver ,address sender , uint256 amountReceived) public virtual override returns (bool){
    //     bool success;
    //     if(isTaxPaused){
    //         success = super.transferFrom(receiver, sender, amountReceived);
    //         return success;
    //     }else{
    //     uint256 receivedAmountWithTax = (amountReceived * tax )/ 100;  
    //     uint256 receiveAmountWithoutTax = receivedAmountWithTax - amountReceived;
    //     success = super.transferFrom(receiver, sender, receiveAmountWithoutTax);
    //     return success;
    //     }
    // }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }
}
