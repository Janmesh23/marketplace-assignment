// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Marketplace {
    struct Listing {
        uint256 token_id;
        address seller;
        uint256 price;
        bool is_sold;
    }

    IERC20 public platform_token_contract;
    IERC721 public nft_contract_instance;
    
    Listing[] public listings;
    

    mapping(address => uint256[]) private user_purchases;

    constructor(address _token_address, address _nft_address) {
        platform_token_contract = IERC20(_token_address);
        nft_contract_instance = IERC721(_nft_address);
    }


    function list_nft(uint256 _token_id, uint256 _price) public {

        nft_contract_instance.transferFrom(msg.sender, address(this), _token_id);
        
        listings.push(Listing({token_id: _token_id,seller: msg.sender,price: _price,is_sold: false}));
    }


    function buy_nft(uint256 _listing_index) public {
        Listing storage listing = listings[_listing_index];
        require(!listing.is_sold, "NFT already sold");
        

        require(platform_token_contract.transferFrom(msg.sender, listing.seller, listing.price), "Token transfer failed");
        

        nft_contract_instance.safeTransferFrom(address(this), msg.sender, listing.token_id);

        listing.is_sold = true;
        user_purchases[msg.sender].push(listing.token_id);
    }




    function get_all_listed_nfts() public view returns (Listing[] memory) {
        uint256 unsold_count = 0;
        for (uint i = 0; i < listings.length; i++) {
            if (!listings[i].is_sold) {
                unsold_count++;
            }
        }

        Listing[] memory unsold = new Listing[](unsold_count);
        uint256 unsold_index = 0;
        for (uint i = 0; i < listings.length; i++) {
            if (!listings[i].is_sold) {
                unsold[unsold_index] = listings[i];
                unsold_index++;
            }
        }
        return unsold;
    }

    function get_all_sold_nfts() public view returns (Listing[] memory) {
        uint256 sold_count = 0;
        for (uint i = 0; i < listings.length; i++) {
            if (listings[i].is_sold) {
                sold_count++;
            }
        }

        Listing[] memory sold = new Listing[](sold_count);
        uint256 sold_index = 0;
        for (uint i = 0; i < listings.length; i++) {
            if (listings[i].is_sold) {
                sold[sold_index] = listings[i];
                sold_index++;
            }
        }
        return sold;
    }


    function get_nft_by_id(uint256 _token_id) public view returns (Listing memory) {
        for (uint i = listings.length-1; i >= 0; i--) {
            if (listings[i].token_id == _token_id) {
                return listings[i];
            }
        }
        revert("Listing not found");
    }


    function get_purchases_by_user(address _user) public view returns (uint256[] memory) {
        return user_purchases[_user];
    }
}