// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721{
    uint public nextTokenId;

    struct Metadata{
        string name;
        string description;
    }

    mapping(uint256 => Metadata) private metadata;
    uint256[] private allNFTs;

    constructor() ERC721("MyNFT", "MNFT"){
        nextTokenId =0;
    }

    function mintNFT(string memory name, string memory description) external{
        nextTokenId++;
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        metadata[tokenId] = Metadata(name, description);
        allNFTs.push(tokenId);
    }

    function getMetadata(uint256 tokenId) external view returns(string memory, string memory){
        Metadata memory m = metadata[tokenId];
        return (m.name, m.description);
    }

    function getAllNFTs() external view returns(uint256[] memory){
        return allNFTs;
    }
}
