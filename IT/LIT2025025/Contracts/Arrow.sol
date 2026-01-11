// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts@5.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {Archer} from "./Archer.sol";

contract Arrow is ERC721, Archer {

    uint256 private _nextTokenId;
    address public seller;
    uint256[] private MintedNFTs; 
    uint256[] private AvailableNFTs;
    uint256 public PriceOfNFT = 100 ;
    uint256[] private NFTsSold;


    constructor() ERC721("Arrow", "ARW")  {
       seller = msg.sender;       
    }

    uint256 private tokenId;

    function safeMint() external  {
        require(msg.sender == seller, "You are not the owner");
        tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        MintedNFTs.push(tokenId);
        AvailableNFTs.push(tokenId);
        
    }

    function _MintedNFTs() public view returns(uint256[] memory) {
        return MintedNFTs;
    }

    function _baseURI () internal pure override returns(string memory)
    {
        return "https://aqua-labour-toad-100.mypinata.cloud/ipfs/bafybeifyrqmzix2nmybhabdzzcpx6nzqjqt3ipgdaatagciqc6jvw5ndhq/";
    }

    function _NFTbase () internal pure returns(string memory)
    {
        return "https://aqua-labour-toad-100.mypinata.cloud/ipfs/bafybeicpsoebkrethgejur3p6kvlubb3vpn5bh25jh4we2ri5znzqnfqmq/";
    }

    using Strings for uint256;

     function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        require(tokenId <10, "NFT does not exist");
        require(_ownerOf(tokenId) != address(0), "NFT does not exist");
        return string(abi.encodePacked( _baseURI(), tokenId.toString(),".json"));
    }

    function NFT(uint256 tokenId) public view returns (string memory)
    {
        require(tokenId <10, "NFT does not exist");
        require(_ownerOf(tokenId) != address(0), "NFT does not exist");
        return string(abi.encodePacked(_NFTbase(), tokenId.toString(), ".png"));
    }

    function transferNFT (address receiver, uint256 tokenId) external {
       require(msg.sender == seller, "Only owner can transfer NFT");
       require(AmountofARCH[receiver]>=100, "You need 100 ARCH to claim this NFT");
       transferFrom(msg.sender, receiver, tokenId);
       AmountofARCH[receiver]-=100;
       for (uint i = 0; i < AvailableNFTs.length; i++) {
        if (AvailableNFTs[i] == tokenId) {
            AvailableNFTs[i] = AvailableNFTs[AvailableNFTs.length - 1];
            AvailableNFTs.pop();
            break;
        }
        
       }
       NFTsSold.push(tokenId);

    }
    
    function _AvailableNFTs() public view returns(uint256[] memory) {
        return AvailableNFTs;
    }

    function _NFTsSold() public view returns(uint256[] memory) {
        return NFTsSold;
    }

    function checkNFT(uint256 tokenId) public view returns (string memory) {
        for (uint i = 0; i < AvailableNFTs.length; i++) {
            if (AvailableNFTs[i] == tokenId) {
                return "Available";
            }
        }
        return "sold";
    }

    

    
}
