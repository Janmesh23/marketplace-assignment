// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./PlatformToken.sol";
import "./OnChainNFT.sol";

contract Marketplace {

    PlatformToken public token;
    OnChainNFT public nft;

    struct Listing {
        uint256 listingId;
        uint256 tokenId;
        address seller;
        uint256 price;
        bool sold;
    }

    uint256 private nextListingId;

    mapping(uint256 => Listing) private listings;
    mapping(address => uint256[]) private userPurchases;

    event NFTListed(uint256 listingId, uint256 tokenId, address seller, uint256 price);
    event NFTSold(uint256 listingId, address buyer);

    constructor(address tokenAddress, address nftAddress) {
        token = PlatformToken(tokenAddress);
        nft = OnChainNFT(nftAddress);
    }

   
    
    function listNFT(uint256 tokenId, uint256 price) external {
        require(nft.ownerOf(tokenId) == msg.sender, "You do not own this NFT");
        require(price > 0, "Price must be greater than zero");

        nft.transferFrom(msg.sender, address(this), tokenId);

        nextListingId++;

        listings[nextListingId] = Listing({
            listingId: nextListingId,
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            sold: false
        });

        emit NFTListed(nextListingId, tokenId, msg.sender, price);
    }

  
    
    function buyNFT(uint256 listingId) external {
        Listing storage item = listings[listingId];

        require(!item.sold, "NFT already sold");

        
        token.transferFrom(msg.sender, item.seller, item.price);

        
        nft.transferFrom(address(this), msg.sender, item.tokenId);

        item.sold = true;
        userPurchases[msg.sender].push(item.tokenId);

        emit NFTSold(listingId, msg.sender);
    }

    
    function getActiveListings() external view returns (Listing[] memory) {
        uint256 count;

        for (uint256 i = 1; i <= nextListingId; i++) {
            if (!listings[i].sold) count++;
        }

        Listing[] memory result = new Listing[](count);
        uint256 index;

        for (uint256 i = 1; i <= nextListingId; i++) {
            if (!listings[i].sold) {
                result[index++] = listings[i];
            }
        }

        return result;
    }

 
    function getSoldListings() external view returns (Listing[] memory) {
        uint256 count;

        for (uint256 i = 1; i <= nextListingId; i++) {
            if (listings[i].sold) count++;
        }

        Listing[] memory result = new Listing[](count);
        uint256 index;

        for (uint256 i = 1; i <= nextListingId; i++) {
            if (listings[i].sold) {
                result[index++] = listings[i];
            }
        }

        return result;
    }

    
    function getListingByTokenId(uint256 tokenId) external view returns (Listing memory) {
        for (uint256 i = 1; i <= nextListingId; i++) {
            if (listings[i].tokenId == tokenId) {
                return listings[i];
            }
        }
        revert("Listing not found");
    }

    
    function getPurchasedNFTs(address user) external view returns (uint256[] memory) {
        return userPurchases[user];
    }
}
