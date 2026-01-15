// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MarketPlace{
    struct Listing{
        address seller;
        address nft;
        uint256 tokenId;
        uint256 price;
        bool sold;
        address buyer;
    
    }

    IERC20 public token;
    uint256 public listingCount;
    mapping(uint256 => Listing) public listings;

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);
    }

    function listNFT(address nft, uint256 tokenId, uint256 price) public{
        IERC721(nft).transferFrom(msg.sender, address(this), tokenId);

        listings[++listingCount] = Listing(
            msg.sender,
            nft,
            tokenId,
            price,
            false,
            address(0)
        );
    }

    function buyNFT(uint256 listingId) public{
        Listing storage l = listings[listingId];
        require(!l.sold, "Already sold");

        token.transferFrom(msg.sender, l.seller, l.price);
        IERC721(l.nft).transferFrom(address(this), msg.sender, l.tokenId);


        l.sold = true;
        l.buyer = msg.sender;
    }

    function viewAllListerNFTs() public view returns(Listing[] memory){
        Listing[] memory arr = new Listing[](listingCount);
        for(uint i = 1; i<= listingCount; i++) {
            arr[i-1] =listings[i];
        }
        return arr;
    }

    function viewSoldNFTs() public view returns(Listing[] memory){
        uint count;
        for(uint i =1;i<listingCount;i++){
            if(listings[i].sold){
                count++;
            }
        }

        Listing[] memory arr = new Listing[](count);
        uint index;
        for(uint i = 1; i<= listingCount; i++){
            if(listings[i].sold){
                arr[index++] = listings[i];
            }
        }
        return arr;
    }

    function viewNFTByTokenId(uint256 tokenId) public view returns(Listing memory){
        for(uint i = 1; i<= listingCount; i++){
            if(listings[i].tokenId == tokenId){
                return listings[i];
            }
        }

        revert("NFT not found");
    }

    function viewNFTsBoughtByUser(address user) external view returns(Listing[] memory){
        uint count;
        for(uint i =1;i<listingCount;i++){
            if(listings[i].buyer == user){
                count++;
            }
        }

        Listing[] memory arr = new Listing[](count);
        uint index;
        for(uint i = 1; i<= listingCount; i++){
            if(listings[i].buyer == user){
                arr[index++] = listings[i];
            }
        }
        return arr;
    }
}

