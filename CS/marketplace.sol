// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./tokencreation.sol";
import "./nfts.sol";

contract maarketplacee {
    
    creation public token;
    creatingnfts public nft;

    constructor(address _token, address _nft) {
        token = creation(_token);
        nft = creatingnfts(_nft);
    }

    struct Listing {
         uint256 tokenId;      
        address seller;
        uint256 price;
        bool sold;
        address buyer;
    }

    Listing[] public listings;

    function listnfts(uint256 _tokenId, uint256 _price) public {
       (,, address owner) = nft.nfts(_tokenId);

        require(owner == msg.sender, "Not owner");
        listings.push(Listing(_tokenId, msg.sender, _price, false, address(0)));
    }

    function buynfts(uint256 index) public {
        Listing storage list = listings[index];
        require(!list.sold, "Already sold");

        require(token.balanceof(msg.sender) >= list.price, "YOU ARE POOR");

        token.transfer(list.seller, list.price);



        nft.transferNFT(list.tokenId, msg.sender);

        list.sold = true;
        list.buyer = msg.sender;
    }

    function viewListed() public view returns(Listing[] memory) {
        return listings;
    }

    function viewSold() public view returns(Listing[] memory) {
        uint256 count;
        for(uint256 i = 0; i < listings.length; i++){
            if(listings[i].sold) count++;
        }

        Listing[] memory arr = new Listing[](count);
        uint256 idx=0;

        for(uint256 i=0; i<listings.length; i++){
            if(listings[i].sold) arr[idx++] = listings[i];
        }
        return arr;
    }


    function viewUserNFTs(address user) public view returns(uint256[] memory) {
        uint256 count;

        for(uint256 i=1; i<=nft.totalnfts(); i++){
            (,, address owner) = nft.nfts(i);
            if(owner == user) count++;
        }

        uint256[] memory arr = new uint256[](count);
        uint256 idx=0;

        for(uint256 i=1; i<=nft.totalnfts(); i++){
            (,, address owner) = nft.nfts(i);
            if(owner == user) arr[idx++] = i;
        }

        return arr;
    }
}