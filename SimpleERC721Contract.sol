// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleERC721 is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 public maxSupply = 2000;
    bool public allowListMintOpen = false;
    bool public publicMintOpen = false;
    mapping(address => bool) addAllowListAddresses;
    constructor()
        ERC721("simpleERC721", "MTK")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
    // function isPublicMintOpen() public onlyOwner{
    //     publicMintOpen = !publicMintOpen;
    // }
    // function isAllowListMintOpen() public onlyOwner{
    //     allowListMintOpen = !allowListMintOpen;
    // }
    function updateMintOptions(bool _publicMintOpen , bool _allowListMintOpen) external {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }
    //add payment
    //add limiting of supply
    function publicMint() public payable {
        require(publicMintOpen , "Public Mint closed");
        require(msg.value == 0.01 ether ,"Not enough funds");
        internalMint();
    }
    //adding allowed address
    function allowList(address[] calldata addresses) external onlyOwner{
        for(uint256 i = 0; i< addresses.length;i++){
            addAllowListAddresses[addresses[i]] = true;
        }
    }
    // The following functions are overrides required by Solidity.
    
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function allowListMint() public payable {
        require(addAllowListAddresses[msg.sender], "You are Not Allowed to Mint");
        require(allowListMintOpen, "AllowList Mint Closed");
        require(msg.value == 0.001 ether, "Not enough funds");
        internalMint();
    }
    function internalMint() internal {
        require(totalSupply() < maxSupply ,"No more supply");
        
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

    function withdraw(address _addr) external onlyOwner{
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }
    
}
