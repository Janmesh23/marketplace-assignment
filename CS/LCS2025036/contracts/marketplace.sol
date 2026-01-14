// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract marketplace is IERC721Receiver {
    IERC20 public token;
    IERC721 public nft;
    constructor(address _token,address _nft) {
        token = IERC20(_token);
        nft = IERC721(_nft);
    }
    struct Listing {
        uint tokenId;
        address seller;
        uint price;
        bool sold;
    }
    mapping(uint => Listing) public listings;
    uint[] public listedNFTs;
    function listNFT(uint tokenId,uint price) public{
        require(nft.ownerOf(tokenId) == msg.sender, "Not Owner");
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing(tokenId, msg.sender, price, false);
        listedNFTs.push(tokenId);
    }
    mapping(address => uint[]) public userPurchases;
    function buyNFT(uint tokenId) public{
        Listing storage item = listings[tokenId];
        require(!item.sold, "Already sold");
        require(token.allowance(msg.sender, address(this)) >= item.price, "Approve tokens first");
        token.transferFrom(msg.sender, item.seller, item.price);
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        item.sold = true;
        userPurchases[msg.sender].push(tokenId);
    }
function getAllListedNFTs() external view returns (Listing[] memory) {
    uint256 count;
    for (uint256 i = 0; i < listedNFTs.length; i++) {
        if (!listings[listedNFTs[i]].sold) {
            count++;
        }
    }

    Listing[] memory result = new Listing[](count);
    uint256 index;
    for (uint256 i = 0; i < listedNFTs.length; i++) {
        uint256 tokenId = listedNFTs[i];
        if (!listings[tokenId].sold) {
            result[index] = listings[tokenId];
            index++;
        }
    }
    return result;
}

function getAllSoldNFTs() external view returns (Listing[] memory) {
    uint256 count;
    for (uint256 i = 0; i < listedNFTs.length; i++) {
        if (listings[listedNFTs[i]].sold) {
            count++;
        }
    }

    Listing[] memory result = new Listing[](count);
    uint256 index;
    for (uint256 i = 0; i < listedNFTs.length; i++) {
        uint256 tokenId = listedNFTs[i];
        if (listings[tokenId].sold) {
            result[index] = listings[tokenId];
            index++;
        }
    }
    return result;
}

function getNFTDetails(uint256 tokenId) external view returns (Listing memory) {
    return listings[tokenId];
}

function getUserPurchases(address user) external view returns (uint256[] memory) {
    return userPurchases[user];
}
function onERC721Received(address,address,uint,bytes calldata) external pure override returns (bytes4) {
    return this.onERC721Received.selector;
}

}