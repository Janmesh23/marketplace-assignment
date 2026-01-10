// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace {
    IERC20 public platformToken;
    IERC721 public nftContract;

    uint public listingCount;

    struct Listing {
        uint tokenId;
        address seller;
        uint price;
        bool sold;
    }

    // listingId to Listing
    mapping(uint => Listing) public listings;

    // user to purchased NFT tokenIds
    mapping(address => uint[]) private _purchasedNFTs;

    constructor(address _tokenAddress, address _nftAddress) {
        platformToken = IERC20(_tokenAddress);
        nftContract = IERC721(_nftAddress);
    }

    function listNFT(uint tokenId, uint price) external {
        require(price > 0, "Price must be greater than zero");
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not NFT owner");

        // Transfering NFT to marketplace
        nftContract.transferFrom(msg.sender, address(this), tokenId);

        listingCount++;

        listings[listingCount] = Listing({
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            sold: false
        });
    }

    function buyNFT(uint listingId) external {
        Listing storage item = listings[listingId];

        require(!item.sold, "NFT already sold");

        // Transfering platform tokens from buyer to seller
        require(
            platformToken.transferFrom(msg.sender, item.seller, item.price),
            "Token transfer failed"
        );

        // Transfering NFT from marketplace to buyer
        nftContract.transferFrom(address(this), msg.sender, item.tokenId);

        item.sold = true;
        _purchasedNFTs[msg.sender].push(item.tokenId);
    }

    function getAllListedNFTs() external view returns (Listing[] memory) {
        uint count = 0;

        for (uint i = 1; i <= listingCount; i++) {
            if (!listings[i].sold) count++;
        }

        Listing[] memory items = new Listing[](count);
        uint index = 0;

        for (uint i = 1; i <= listingCount; i++) {
            if (!listings[i].sold) {
                items[index] = listings[i];
                index++;
            }
        }

        return items;
    }

    function getAllSoldNFTs() external view returns (Listing[] memory) {
        uint count = 0;

        for (uint i = 1; i <= listingCount; i++) {
            if (listings[i].sold) count++;
        }

        Listing[] memory items = new Listing[](count);
        uint index = 0;

        for (uint i = 1; i <= listingCount; i++) {
            if (listings[i].sold) {
                items[index] = listings[i];
                index++;
            }
        }

        return items;
    }

    function getListingByTokenId(uint tokenId) external view returns (Listing memory) {
        for (uint i = 1; i <= listingCount; i++) {
            if (listings[i].tokenId == tokenId) {
                return listings[i];
            }
        }
        revert("Listing not found");
    }

    function getPurchasedNFTs(address user) external view returns (uint[] memory) {
        return _purchasedNFTs[user];
    }
}
