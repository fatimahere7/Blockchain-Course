// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import {ERC721Pausable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract MyNFT is ERC721 , Ownable ,ERC721Enumerable, ERC2981 , ERC721Pausable{

    //----------Variables-----------

    using Strings for uint256;
    uint256 public maxSupply = 10000;
    uint256 public mintPrice = 0.02 ether;
    uint256 public nextId = 1;
    string public baseURI = "https://my-nft.com/metadata/";
    string public hiddenURI = "ipfs://QmSomeHiddenFolder/hidden.json";
    bool public revealed = false;
    bytes32 public merkleRoot;
    bool public mintPaused = false;
    bool public soulBound = false;
    

    //-----------Constructor---------------

    constructor() ERC721("MyNFT", "MNFT")  Ownable(msg.sender){
        _setDefaultRoyalty(msg.sender , 500);
    }

    //------------Mappings------------------
    mapping(uint256 => string) customURI;


    //-------------Events-----------------


    event Minted(address minter , uint256 tokenId); 


    //----URI Related Functions

    function _baseURI() internal view override returns(string memory){
        return baseURI;
    }
    
    function tokenURI(uint256 tokenId) public view override returns(string memory){
        if(revealed){ return hiddenURI; }
        if(bytes(customURI[tokenId]).length > 0){
            return customURI[tokenId];
        }
        return string(abi.encodePacked(baseURI , tokenId.toString(), ".json"));
    }
    function IsRevealed() public onlyOwner{
        revealed = !revealed;
    }
    function setCustomURI(uint256 tokenId,string calldata uri) external onlyOwner{
        customURI[tokenId] = uri;
    }

    //-------------Minting-----------------
    function mintNFT() public {
        require(totalSupply() < maxSupply , "Reached Maximum Supply");
        uint256 tokenId = nextId++;
        _safeMint(msg.sender, tokenId);
        emit Minted(msg.sender , tokenId);
    }
      
    function _mintOne(address _to) internal {
        uint256 tokenId = totalSupply() + 1;
        _safeMint(_to, tokenId);
        emit Minted(_to, tokenId);
    } 

    //Public Mint
    function publicMint(uint256 amount) public payable _allowedMint(amount){
       require(mintPaused,"Minting is Paused rn");
       for(uint256 i = 0 ; i < amount ; i++){
           _mintOne(msg.sender);
       }
    }
 
    //OnlyOwner Mint
    function ownerMint(address to) external onlyOwner{
        uint256 tokenId = nextId++;
        _safeMint(to, tokenId);
        emit Minted(to , tokenId);
    }
    
    modifier _allowedMint(uint256 _amount){
        require(totalSupply() + _amount <= maxSupply , "Reached Maximum Supply");
        require(msg.value == mintPrice , "Not exact ETH");
        _;
    }
    function toggleMint() public onlyOwner{
        mintPaused = !mintPaused;
    }


    //======= Whitelist Mint =======
    function whiteListMint(bytes32[] calldata proof, uint256 amount) external payable _allowedMint(amount){
        require(msg.sender == tx.origin, "Cant transact");
        require(isWhiteListed(msg.sender , proof),"Not Whitelisted");
        uint256 tokenId = nextId++;
        _safeMint(msg.sender, tokenId);

    } 
    
    function isWhiteListed(address user , bytes32[] calldata proof) public view returns(bool){
        return MerkleProof.verify(proof,merkleRoot, keccak256(abi.encodePacked(user)));
    } 
    
   //======== SoulBound and Royalties=======
    
    function toogleSoulBound() public onlyOwner{
        soulBound = !soulBound;
    }

    function setRoyalty(address receiver , uint96 fee) external onlyOwner{
        _setDefaultRoyalty(receiver , fee);
    }
    // The following functions are overrides required by Solidity.
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable ,ERC721Pausable)
        returns (address)
    {
        if(soulBound){
            address from = _ownerOf(tokenId);
            if(from != address(0)){
                revert("Soulbound: cannot transfer.");
            }
        }
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
        override(ERC721, ERC721Enumerable , ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    //----------Pausable--------------
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

}
