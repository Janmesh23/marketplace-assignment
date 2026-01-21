// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

    interface IToken {
        function balanceOfUser(address user) external view returns (uint256);
        function transferFrom(address from, address to, uint256 amount) external returns (bool);
    }

    interface INFT {
        function nfts(uint256 nftId) external view returns (uint256, string memory, string memory, address);
        function transferNFT(uint256 nftId, address currentOwner, address newOwner) external;
    }

contract Marketplace{
    
    IToken private token;
    INFT private nft;

    constructor(address tokenAddress, address nftAddress){
        token = IToken(tokenAddress);
        nft = INFT(nftAddress);
    }

    struct NFTInfo {
        uint256 NFTId;
        string name;
        string description;
    }

    struct Listing {
        NFTInfo nft;
        address seller;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => Listing) private listings;
    uint256[] private allListedNFTsIds;
    mapping(address => uint256[]) private purchasedNFTsOfUser;

    function listNFT(uint256 nft_Id, uint256 Price) public {
        require(Price>0, "Please enter correct price for the NFT");

        (uint256 idNFT, string memory nameNFT, string memory descNFT, address ownerNFT) = nft.nfts(nft_Id);

        require(ownerNFT!=address(0), "NFT doesn't exist");
        require(ownerNFT==msg.sender, "You are not the owner of the NFT");

        nft.transferNFT(nft_Id,msg.sender,address(this));

        listings[nft_Id] = Listing({
            nft : NFTInfo({
                NFTId: idNFT,
                name: nameNFT,
                description: descNFT
            }),
            seller: msg.sender, 
            price: Price,
            sold: false
        });

        allListedNFTsIds.push(nft_Id);
    }

    function buyNFT(uint256 NFTid) public {
        require(listings[NFTid].seller != address(0), "NFT not listed");
        require(!listings[NFTid].sold, "NFT Already sold");
        require(token.balanceOfUser(msg.sender)>=listings[NFTid].price, "Insufficient tokens to buy NFT");

        token.transferFrom(msg.sender,listings[NFTid].seller,listings[NFTid].price);
        nft.transferNFT(NFTid,address(this),msg.sender);

        listings[NFTid].sold=true;
        purchasedNFTsOfUser[msg.sender].push(NFTid);

    }

    function allListedNFTs() public view returns (Listing[] memory){
        uint256 count = 0;
        for (uint256 i = 0 ; i<allListedNFTsIds.length; i++){
            if (!listings[allListedNFTsIds[i]].sold){
                count++;
            }
        }

        Listing[] memory list_of_all_NFTs = new Listing[](count);

        uint256 index=0;
        for (uint256 i = 0 ; i<allListedNFTsIds.length; i++){
            if (!listings[allListedNFTsIds[i]].sold){
                list_of_all_NFTs[index] = listings[allListedNFTsIds[i]];
                index++;
            }
        }

        return list_of_all_NFTs;
    }

    function allSoldNFTs() public view returns (Listing[] memory){
        uint256 count = 0;
        for (uint256 i = 0 ; i<allListedNFTsIds.length; i++){
            if (listings[allListedNFTsIds[i]].sold){
                count++;
            }
        }

        Listing[] memory list_of_all_sold_NFTs = new Listing[](count);

        uint256 index=0;
        for (uint256 i = 0 ; i<allListedNFTsIds.length; i++){
            if (listings[allListedNFTsIds[i]].sold){
                list_of_all_sold_NFTs[index] = listings[allListedNFTsIds[i]];
                index++;
            }
        }

        return list_of_all_sold_NFTs;
    }

    function aNFT(uint256 tokenId) public view returns (Listing memory){
        return listings[tokenId];
    }

    function allNFT(address buyer) public view returns (Listing[] memory){

        Listing[] memory list_of_all_NFTs_of_User = new Listing[](purchasedNFTsOfUser[buyer].length);

        for (uint256 i=0;i<purchasedNFTsOfUser[buyer].length;i++){
            list_of_all_NFTs_of_User[i] = listings[purchasedNFTsOfUser[buyer][i]];
        }

        return list_of_all_NFTs_of_User;
    }
    
}