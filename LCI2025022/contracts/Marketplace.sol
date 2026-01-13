// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace {

    IERC20 public token;
    IERC721 public nft;

    uint256 public vol;

    constructor(address t, address n) {
        token = IERC20(t);
        nft = IERC721(n);
    }

    struct Item {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool sold;
    }

    Item[] public lst;
    mapping(address => uint256[]) public myBuy;

    function getAllListedNFTs() public view returns(Item[] memory) {
        return lst;
    }

    function listNFT(uint256 id, uint256 price) public {
        require(nft.ownerOf(id) == msg.sender);
        nft.transferFrom(msg.sender, address(this), id);

        Item memory it;
        it.tokenId = id;
        it.seller = msg.sender;
        it.price = price;
        it.sold = false;

        lst.push(it);
    }

    function changePrice(uint256 id, uint256 newPrice) public {
        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].tokenId == id) {
                require(lst[i].sold == false);
                require(lst[i].seller == msg.sender);
                lst[i].price = newPrice;
                return;
            }
        }
        revert("no");
    }

    function cancelListing(uint256 id) public {
        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].tokenId == id) {
                require(lst[i].sold == false);
                require(lst[i].seller == msg.sender);
                lst[i].sold = true;
                nft.transferFrom(address(this), msg.sender, id);
                return;
            }
        }
        revert("no");
    }

    function getMyPurchases(address u) public view returns(uint256[] memory) {
        return myBuy[u];
    }

    function buyNFT(uint256 id) public {
        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].tokenId == id) {
                require(lst[i].sold == false);

                token.transferFrom(msg.sender, lst[i].seller, lst[i].price);
                nft.transferFrom(address(this), msg.sender, id);

                lst[i].sold = true;
                myBuy[msg.sender].push(id);
                vol += lst[i].price;
                return;
            }
        }
        revert("no");
    }

    function getNFTByTokenId(uint256 id) public view returns(Item memory) {
        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].tokenId == id) {
                return lst[i];
            }
        }
        revert("no");
    }

    function getSoldNFTs() public view returns(Item[] memory) {
        uint c = 0;
        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].sold) c++;
        }

        Item[] memory res = new Item[](c);
        uint k = 0;

        for(uint i = 0; i < lst.length; i++) {
            if(lst[i].sold) {
                res[k] = lst[i];
                k++;
            }
        }

        return res;
    }
}
