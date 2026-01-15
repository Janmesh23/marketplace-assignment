// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NFT{
    
    struct NFTDetails {
        uint256 NFTId;
        string NFTName;
        string Desc;
        address owner;
    }

    mapping(uint256 => NFTDetails) public nfts;

    uint256[] private allNFTSId;

    uint256 private IDiterator = 1;

    function NFTMint(string memory _name,string memory _desc) public {

        nfts[IDiterator] = NFTDetails({
            NFTId : IDiterator,
            NFTName : _name,
            Desc : _desc,
            owner : msg.sender
        });

        allNFTSId.push(IDiterator);
        IDiterator++;
    }

    function NFTDetail(uint nft_Id) public view returns (NFTDetails memory){
            return nfts[nft_Id];
    }

    function AllNFTDetails() public view returns (NFTDetails[] memory){

        NFTDetails[] memory allNFTS = new NFTDetails[](allNFTSId.length);

        for (uint256 i=0;i<allNFTSId.length;i++){
            allNFTS[i] = nfts[allNFTSId[i]];
        }
        return allNFTS;
    }

    function transferNFT(uint256 nftID, address currentOwner, address newOwner) public {
        require(nfts[nftID].owner == currentOwner, "Not NFT Owner");
        nfts[nftID].owner = newOwner;
    }

}