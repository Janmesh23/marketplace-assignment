// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./inft.sol";
import "./itoken.sol";

contract NFTMarketplace {

    INFT public nft;
    IToken public token;

    mapping(uint256 => address) public sellerofNFT;
    mapping(uint256 => uint256) public priceofNFT;
    mapping(uint256 => bool) public isListed;
    mapping(uint256 => bool) public isSold;

    uint256[] public listedNFTs;
    uint256[] public soldNFTs;

    mapping(address => uint256[]) public purchasedNFTs;

    constructor(address nftaddress, address tokenaddress) {
        nft = INFT(nftaddress);
        token = IToken(tokenaddress);
    }

    function listNFT(uint256 tokenId, uint256 price) external {
        require(nft.NFTexists(tokenId), "NFT not exist");
        require(!isListed[tokenId], "Already listed");
        require(nft.ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Invalid price");


        nft.transferFrom(msg.sender, address(this), tokenId);

        sellerofNFT[tokenId] = msg.sender;
        priceofNFT[tokenId] = price;
        isListed[tokenId] = true;
        isSold[tokenId] = false;

        listedNFTs.push(tokenId);
    }

    function buyNFT(uint256 tokenId) external {
        require(isListed[tokenId], "NFT not listed");
        require(!isSold[tokenId], "Already sold");

        address seller = sellerofNFT[tokenId];
        uint256 price = priceofNFT[tokenId];

        token.transferFrom(msg.sender, seller, price);
        nft.transferFrom(address(this), msg.sender, tokenId);

        isListed[tokenId] = false;
        isSold[tokenId] = true;

        soldNFTs.push(tokenId);
        purchasedNFTs[msg.sender].push(tokenId);

        for (uint256 i = 0; i < listedNFTs.length; i++) {
            if (listedNFTs[i] == tokenId) {
                listedNFTs[i] = listedNFTs[listedNFTs.length - 1];
                listedNFTs.pop();
                break;
            }
        }
    }

    function getListedNFTs() external view returns (uint256[] memory) {
        return listedNFTs;
    }

    function getSoldNFTs() external view returns (uint256[] memory) {
        return soldNFTs;
    }

    function getNFT(uint256 tokenId) external view returns (address seller, uint256 price, bool listed, bool sold){
        return (
            sellerofNFT[tokenId],
            priceofNFT[tokenId],
            isListed[tokenId],
            isSold[tokenId]
        );
    }

    function getNFTsByBuyer(address user) external view returns (uint256[] memory){
        return purchasedNFTs[user];
    }
}
