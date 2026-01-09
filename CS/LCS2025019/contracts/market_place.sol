// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    =========================================================
        MARKETPLACE CONTRACT FOR TOKEN AND NFT EXCHANGE
    =========================================================

    FEATURES:
    - IMPORTING contracts from Outside
    - User minting
    - Easy frontend listing
    
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// We are importing our previous contracts
import "./NFT_assign.sol";
import "./Token_buy.sol";

//These 2 are for using standard ERC20, ERC721 interfaces
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketPlace {


    TOKENexchange public tokenContract; // Creating variable which helds ERC20 type contract adress, INITIALLY - 0x00000...000
    NFTMetadata public nftContract; // Creating variable which helds ERC721 type contract adress, INITIALLY - 0x00000...000

    

    uint public availNFTno = 0;

    constructor(address _tokenAddress, address _nftAddress){
        tokenContract = TOKENexchange(_tokenAddress); //Passing adress of our contract ERC20 type we deployed
        nftContract = NFTMetadata(_nftAddress);   //Passing adress of our contract ERC721 type we deployed
    }

    struct List{
        address seller;
        uint256 price;   //Price Set by the Selle Himself
        bool isSold;
    }

    mapping (uint256 => List) public nftAvailable; //tokenId => List of Seller, Price, IsSold

    mapping (uint256 => string) public soldNFTs;

    function sellNFT ( uint256 tokenId, uint256 price) external {
        // NFT must be owned by the person wants to sell
        require(nftContract.ownerOf(tokenId) == msg.sender, "NFT not Belongs to you my LORD");

        // Seller should set some Price
        require(price>0, "Price should not be 0, keep some value");

        // Selling by an owner means transferring NFT to the MarketPlace Contract
        nftContract.transferFrom(msg.sender, address(this), tokenId);

        // Listing available NFTs in MarketPlace
        nftAvailable[tokenId] = List(msg.sender, price, false);
        availNFTno++;
    }

    uint256 public soldcount = 0;
    function buyNFT(uint256 tokenId) external {
        List storage item = nftAvailable[tokenId];

        // Item must be availble in market place
        require(item.price > 0, "NFT not available");

        // Item must be not sold
        require(item.isSold == false, "Oops,THE ITEM already sold!!");

        // Buyer must contain enough ammount of tokens
        require(tokenContract.transferFrom(msg.sender, item.seller, item.price), "Payment Failed");

        // Transfer of NFTs to the buyer
        nftContract.transferFrom(address(this), msg.sender, tokenId);

        //Item sold
        item.isSold = true;

        // soldNFTs[tokenId] = msg.sender;

        soldcount++;
    }
    

    /*
        =====================================================
        GET ALL NFTs AVAILABLE IN MARKET TO BUY (FRONTEND FRIENDLY)
        =====================================================
    */
    

    function alvailableNFTs() external view  returns (List[] memory) {

        uint256 totalNFTs = nftContract.nextTokenId();

        List[] memory NFTs = new List[](availNFTno);

        uint256 items = 0;
        for(uint256 i = 0; i < totalNFTs; i++) {
            if(nftAvailable[i].price>0 && nftAvailable[i].isSold == false){
                NFTs[items] = nftAvailable[i];
                items++;
            }
        }
        return NFTs;
    }

     /*
        =====================================================
                FUNCTION TO SEE ALL SOLD NFTs
        =====================================================
    */

    function Sold() external view returns (List[] memory) {

        uint256 totalNFTs = nftContract.nextTokenId();


        List[] memory SoldNFT = new List[](soldcount);
        uint256 items = 0;
        for(uint256 i = 0; i < totalNFTs; i++) {
            if( nftAvailable[i].price > 0 && nftAvailable[i].isSold == true) {
                SoldNFT[items] = nftAvailable[i];
                items++;
            }
        }

        return SoldNFT;
    }


    


}
