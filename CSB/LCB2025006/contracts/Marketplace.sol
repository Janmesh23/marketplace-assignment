// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ERC20Minimal {
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

interface ERC721Minimal {
    struct NFTMetadata {
        string name;
        string description;
    } 
    function transferFrom(address from,address to,uint256 tokenId) external;
    function ownerOf(uint256 tokenId) external view returns(address);
    function getApproved(uint256 tokenId) external view returns(address);
    function retrieveMetaData(uint _tokenId) external view returns(NFTMetadata memory);
    
}

contract Marketplace {
    ERC20Minimal public TokenContract;
    ERC721Minimal public NFTContract;

    constructor(address _TokenContract, address _NFTContract) {
        TokenContract = ERC20Minimal(_TokenContract);
        NFTContract = ERC721Minimal(_NFTContract);
    }

    struct Listing{
        address seller;
        uint256 tokenId;
        uint256 price;
        bool sold;
    }

    struct Sale {
        uint256 tokenId;
        address seller;
        address buyer;
        uint256 price;
    }

    mapping (uint=>Listing) public salesListing;
    uint[] listedNFTTokenIds;
    mapping (address=>uint[]) public purchasedNFTs;
    Sale[] public salesHistory;

    event Listed(uint tokenId, address seller, uint price);
    event Sold(uint tokenId, address buyer);
    event Cancelled(uint tokenId);


    function listNFT(uint _tokenId,uint _price) public{
        require(NFTContract.ownerOf(_tokenId)==msg.sender,"You are not the owner of this NFT");
        require(NFTContract.getApproved(_tokenId)==address(this),"NFT is not approved for sale");
        require(salesListing[_tokenId].seller==address(0),"NFT is already listed for sale");
        require(_price>0,"Price must be greater than zero");
        
        NFTContract.transferFrom(msg.sender,address(this),_tokenId);
        salesListing[_tokenId]=Listing(msg.sender,_tokenId,_price,false);
        listedNFTTokenIds.push(_tokenId);

        emit Listed(_tokenId,msg.sender,_price);
    }

    function buyNFT(uint _tokenId) public {
        require(salesListing[_tokenId].seller!=address(0),"NFT is not listed for sale");
        require(TokenContract.allowance(msg.sender,address(this))>=salesListing[_tokenId].price,"Insufficient allowance amount");
        require(!salesListing[_tokenId].sold,"NFT has already been sold");

        address seller = salesListing[_tokenId].seller;
        uint price = salesListing[_tokenId].price;

        salesHistory.push(
            Sale(
                _tokenId,
                salesListing[_tokenId].seller,
                msg.sender,
                salesListing[_tokenId].price
            )
        );

        salesListing[_tokenId].sold=true;
        salesListing[_tokenId].seller = address(0);
        purchasedNFTs[msg.sender].push(_tokenId);

        NFTContract.transferFrom(address(this),msg.sender,_tokenId);
        TokenContract.transferFrom(msg.sender,seller,price);

        emit Sold(_tokenId, msg.sender);
    }

    function cancelListing(uint _tokenId) public {
        require(msg.sender==salesListing[_tokenId].seller,"You are not the seller");
        require(!salesListing[_tokenId].sold,"Already Sold");

        NFTContract.transferFrom(address(this),msg.sender,_tokenId);
        delete salesListing[_tokenId];

        emit Cancelled(_tokenId);
    }


    function viewListedNFTs() public view returns ( Listing[] memory){
        uint length = listedNFTTokenIds.length;
        uint count = 0;
        
        for(uint i=0;i<length;i++){
            if (salesListing[listedNFTTokenIds[i]].seller != address(0) && !salesListing[listedNFTTokenIds[i]].sold){
                count++;
            }
        }

        Listing[] memory list = new Listing[](count);
        uint counter =0;
        for(uint i=0;i<length;i++){
            if (salesListing[listedNFTTokenIds[i]].seller != address(0) && !salesListing[listedNFTTokenIds[i]].sold){
                list[counter]= salesListing[listedNFTTokenIds[i]];
                counter++;
            }
        }
        return list;
    }

    function viewSoldNFTs() public view returns (Sale[] memory){
        return salesHistory;
    }

    function viewNFTDetails(uint _tokenId) public view returns(ERC721Minimal.NFTMetadata memory){
        return (NFTContract.retrieveMetaData(_tokenId));  
    }

    function viewNFTsPurchased(address _buyer) public view returns(uint[] memory){
        require(_buyer !=address(0),"Not a valid address");
        return purchasedNFTs[_buyer];
    }


    
}