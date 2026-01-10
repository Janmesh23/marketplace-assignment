// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract nft_contract is ERC721 {

    struct NFT_metadata {
        uint256 id;
        string name;
        string description;
        address owner;
    }

    mapping(uint256 => NFT_metadata) private nft_details;

    constructor() ERC721("nft", "NFT") {}
    
    uint256 private next_token_id;

    function mintNFT(string memory _name, string memory _description) public returns (uint256) {
        uint256 current_id = next_token_id;
        _safeMint(msg.sender, current_id);
        
        nft_details[current_id] = NFT_metadata({
            id: current_id,
            name: _name,
            description: _description,
            owner: msg.sender
        });

        next_token_id++;
        return current_id;
    }


    function get_metadata(uint256 token_id) public view returns (NFT_metadata memory) {
        address current_owner = ownerOf(token_id);
        NFT_metadata memory nft = nft_details[token_id];
        nft.owner = current_owner; 
        return nft;
    }

    function fetchAllNFTs() public view returns (NFT_metadata[] memory) {
        NFT_metadata[] memory NFTs = new NFT_metadata[](next_token_id);
        
        for (uint256 i = 0; i < next_token_id; i++) {
            NFT_metadata memory nft = nft_details[i];
            nft.owner = ownerOf(i); 
            NFTs[i] = nft;
        }
        
        return NFTs;
    }
}