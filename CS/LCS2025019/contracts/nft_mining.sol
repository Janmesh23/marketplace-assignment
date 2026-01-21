// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    =========================================================
    NFT CONTRACT FOR MINING METADATA
    =========================================================

    FEATURES:
    - ERC721 NFT
    - User minting
    - Easy frontend listing
    - Events for indexing
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMetadata is ERC721, Ownable {

    // Counter for NFT IDs
    uint256 public nextTokenId;

    struct NFTmetadata{
        string name;
        string description;
    }
    // tokenId => metadata about NFT
    mapping(uint256 => NFTmetadata) private _tokenURIs;

    // 🔔 Event for frontend / backend indexing
    event NFTMinted(
        uint256 indexed tokenId,
        address indexed owner,
        NFTmetadata metadata
    );

    constructor()
        ERC721("NFTMetadata", "NFTDAT")
        Ownable(msg.sender)
    {}

    /*
        =====================================================
        MINT NFT
        =====================================================

        metadata example:
        name: "winter_token1"
        description: "A Snowy description of a cool NFT"
    */
    function mintNFT(NFTmetadata memory metadata) external {
        uint256 tokenId = nextTokenId;
        nextTokenId++;

        // Mint NFT to user
        _safeMint(msg.sender, tokenId);

        // Store metadata URI
        _tokenURIs[tokenId] = metadata;

        // Emit event for website listing
        emit NFTMinted(tokenId, msg.sender, metadata);
    }

    
    

    function getFormattedMetadata(uint256 tokenId)
    external
    view
    returns (string memory)
{
    require(_ownerOf(tokenId) != address(0), "NFT does not exist");

    NFTmetadata storage data = _tokenURIs[tokenId];

    return string(
        abi.encodePacked(
            "NAME : ",
            data.name,
            "\nDescription : ",
            data.description
        )
    );
}


    /*
        =====================================================
        GET ALL NFTs OF A USER (FRONTEND FRIENDLY)
        =====================================================
    */
    function getMyNFTs() external view returns (uint256[] memory) {
        uint256 balance = balanceOf(msg.sender);
        uint256[] memory ids = new uint256[](balance);

        uint256 index = 0;
        for (uint256 i = 0; i < nextTokenId; i++) {
            if (_ownerOf(i) == msg.sender) {
                ids[index] = i+1;
                index++;
            }
        }
        return ids;
    }
}