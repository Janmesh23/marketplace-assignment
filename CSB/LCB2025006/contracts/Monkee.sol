// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Monkee is ERC721 {
    uint private nextTokenId;
    struct NFTMetadata {
        string name;
        string description;
    }
    mapping(uint=>NFTMetadata) private monkeeStats;

    constructor() ERC721("Monkee", "MNK") {}

    function mint(string memory _name,string memory _description) public returns (uint) {
        uint tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        monkeeStats[tokenId].name = _name;
        monkeeStats[tokenId].description = _description;
        nextTokenId++;
        return (tokenId);
    }

    function retrieveMetaData(uint _tokenId) public view returns(NFTMetadata memory){
        require(_tokenId<nextTokenId,"Token does not exist");
        return (monkeeStats[_tokenId]);
    }

    function fetchAllNFTs() public view returns (NFTMetadata[] memory){
        NFTMetadata[] memory list = new NFTMetadata[](nextTokenId);
        for(uint i=0;i<nextTokenId;i++){
            list[i] = monkeeStats[i];
        }
        return list;
    }

}