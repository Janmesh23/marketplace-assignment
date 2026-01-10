// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract OnChainNFT is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds ;

    struct NFTMetadata {
        string name;
        string description;
    }

    // tokenId => metadata
    mapping(uint => NFTMetadata) private _metadata;

    // list of all minted tokenIds
    uint[] private TokenIds;

    constructor() ERC721("OnChain NFT", "ONFT") {}

    function mintNFT(string memory name, string memory description) external {
        _tokenIds.increment();
        uint newTokenId = _tokenIds.current();

        _safeMint(msg.sender, newTokenId);

        _metadata[newTokenId] = NFTMetadata(name, description);
        TokenIds.push(newTokenId);
    }

    function getMetadata(uint tokenId) external view returns (string memory, string memory) {
        require(_ownerOf(tokenId) != address(0), "NFT does not exist");
        NFTMetadata memory data = _metadata[tokenId];
        return (data.name, data.description);
    }

    function getAllMintedNFTs() external view returns (uint[] memory) {
        return TokenIds;
    }
}
