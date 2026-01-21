// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OnChainNFT is ERC721 {

    uint256 public tokenCount;

    mapping(uint256 => string) private nftName;
    mapping(uint256 => string) private nftDescription;
    mapping(uint256 => bool) private exists;

    uint256[] private MintedNFTs;

    constructor() ERC721("Create NFTs", "NFT") {}

    function mintNFT(string memory name, string memory description) external {
        tokenCount++;
        uint256 tokenId = tokenCount;

        _mint(msg.sender, tokenId);

        nftName[tokenId] = name;
        nftDescription[tokenId] = description;
        exists[tokenId] = true;

        MintedNFTs.push(tokenId);
    }

    function NFTexists(uint256 tokenId) external view returns (bool) {
        return exists[tokenId];
    }

    function ShowNFT(uint256 tokenId) external view returns (string memory, string memory, address)
    {
        require(exists[tokenId], "NFT not exist");
        return (nftName[tokenId], nftDescription[tokenId], ownerOf(tokenId));
    }

    function AllMintedNFTs() external view returns (uint256[] memory) {
        return MintedNFTs;
    }
}
