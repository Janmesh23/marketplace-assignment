// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourNFT is ERC721, Ownable {

    uint256 nextTokenId=0;
    struct dataNFT{
        string Name;
        string Description;
        string URI;
        address CreatorAdd;
    }
    mapping(uint256 => dataNFT) private TokenMD; 

    constructor()
        ERC721("YourNFT", "YOWNNFT")
        Ownable(msg.sender)
    {}

    function mintNFT(string memory _name,string memory _Description,string memory _URI,address _add) external{
        uint256 tokenId=nextTokenId;
        _safeMint(msg.sender,tokenId);
        nextTokenId++;
        TokenMD[tokenId].Name = _name;
        TokenMD[tokenId].Description = _Description;
        TokenMD[tokenId].URI = _URI;
        TokenMD[tokenId].CreatorAdd = _add;
    }

    function getNFTMetaData(uint256 _tokenId) public view returns(string memory name,string memory description,string memory URI,address Creator_Add){
        require(_ownerOf(_tokenId)!=address(0),"NFT does not exist"); 
        name=TokenMD[_tokenId].Name;
        description=TokenMD[_tokenId].Description;
        URI=TokenMD[_tokenId].URI;
        Creator_Add=TokenMD[_tokenId].CreatorAdd;
        return(name,description,URI,Creator_Add);
    }
    function MyNFT(address owner) external view returns(uint256[] memory){
        uint256 balance = balanceOf(owner);
        uint256[] memory ids = new uint256[](balance);

        uint256 index = 0;
        for (uint256 i = 0; i < nextTokenId; i++) {
            if (_ownerOf(i) == owner) {
                ids[index] = i;
                index++;
            }
        }
        return ids;
    
    }        
}