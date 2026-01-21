// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract onChainNFT is ERC721{
    address owner;
    constructor() ERC721("Prakhar's NFT","praG"){
        owner = payable(msg.sender);
    }
    struct NFTDATA{
        string name;
        string description;
    }
    mapping(uint=>NFTDATA) nfts;
    uint[] nftcollection;
    uint counter=0;


    function assign(string memory _name,string memory _description) public{
        counter++;
        _safeMint(msg.sender, counter);
        nfts[counter] = NFTDATA(_name,_description);
        nftcollection.push(counter);
    }

    function getNFT(uint tokenId) public view returns (string memory name,string memory description,address){
        return(nfts[tokenId].name,nfts[tokenId].description,ownerOf(tokenId));
    }
    function getAllNFTs() public view returns (uint[] memory){
        return nftcollection;
    }
    
}