// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OnChainNFT is ERC721 {

    struct NFTInfo {
        string name;
        string description;
    }

    uint256 private nextTokenId;
    uint256[] private mintedNFTs;

    mapping(uint256 => NFTInfo) private nftDetails;

    constructor() ERC721("OnChain NFT", "OCNFT") {}

    
   
    
    function mintNFT(string memory name, string memory description) external {
        nextTokenId++;

        _mint(msg.sender, nextTokenId);

        nftDetails[nextTokenId] = NFTInfo(name, description);
        mintedNFTs.push(nextTokenId);
    }

    
    function getNFT(uint256 tokenId)
        external
        view
        returns (string memory name, string memory description)
    {
        require(_ownerOf(tokenId) != address(0), "NFT does not exist");


        NFTInfo memory info = nftDetails[tokenId];
        return (info.name, info.description);
    }

    function getAllMintedNFTs() external view returns (uint256[] memory) {
        return mintedNFTs;
    }
}
