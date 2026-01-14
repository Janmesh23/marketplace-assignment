//SPDX-License-Identifier: MIT
pragma solidity^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract marketplace{
    struct listings{
        uint tokenID;
        address seller;
        bool isSold;
        uint price;
        bool exist;
    }

        IERC20 public tokenContract; 
        IERC721 public nftContract;

            mapping(uint=>listings) public listing;
            mapping(address => uint256[]) public purchasedNFTs;
            uint[] allTokenIDs;

            constructor(address tokenAddress, address nftAddress){
                tokenContract =  IERC20 (tokenAddress);
                nftContract = IERC721(nftAddress);
            }
                function listNFT(uint tokenID, uint price) public {
                    require(price>0, "price cannot be zero");
                    require(nftContract.ownerOf(tokenID)== msg.sender, "not the owner");

                    nftContract.transferFrom(msg.sender, address(this), tokenID);
                    listing[tokenID]= listings(tokenID,msg.sender,false,price,true);
                    allTokenIDs.push(tokenID);

                }
                    function buyNFT(uint tokenID) public {
                        listings storage list = listing[tokenID];
                        require(list.exist, "NFT not exists");
                        require(!list.isSold, "NFT already sold");
                        tokenContract.transferFrom(msg.sender, list.seller,list.price);
                        nftContract.transferFrom(address(this), msg.sender,list.tokenID);
                        
                            list.isSold = true;
                            purchasedNFTs[msg.sender].push(tokenID);
                    }
                        function getAllListedNFT() public view returns(listings[] memory){
                            uint count=0;
                            for(uint i=0; i<allTokenIDs.length; i++){
                                uint tokenID = allTokenIDs[i];
                                if(listing[tokenID].exist && !listing[tokenID].isSold)
                                count++;
                            }
  
                        
                        listings[] memory result = new listings[](count);
                        uint idx=0;
                        for(uint i=0; i<allTokenIDs.length; i++){
                            uint tokenID = allTokenIDs[i];
                            if(listing[tokenID].exist && !listing[tokenID].isSold){
                                result[idx]= listing[tokenID];
                                idx++;
                            }
                        }

                            return result;
                        }   
                        function getAllSoldNFT() public view returns(listings[] memory){
                            uint count=0;
                            for(uint i=0; i<allTokenIDs.length; i++){
                                uint tokenID = allTokenIDs[i];
                                if(listing[tokenID].exist && listing[tokenID].isSold)
                                count++;
                            }
  
                        
                        listings[] memory result = new listings[](count);
                        uint idx=0;
                        for(uint i=0; i<allTokenIDs.length; i++){
                            uint tokenID = allTokenIDs[i];
                            if(listing[tokenID].exist && listing[tokenID].isSold){
                                result[idx]= listing[tokenID];
                                idx++;
                            }
                        }

                            return result;
                        } 
                            function getListings(uint tokenID) public view returns(listings memory){
                                require(listing[tokenID].exist, "listings not found");
                                return listing[tokenID];

                            }

                                function getPurchasesByUser(address user) public view returns(uint256[] memory){
                                    return purchasedNFTs[user];

                                }


                    
}