// SPDX-License-Identifier: MIT


pragma solidity ^0.8.31;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace{
  IERC20 public token; 
  IERC721 public Nft_contract;

  constructor (address tokenaddress,address _nftaddress)
  {
    token=(IERC20)(tokenaddress);
    Nft_contract=(IERC721)(_nftaddress);
  }

  struct List{
    uint id;
    bool sold;
    uint price;
    address seller;
}
mapping (uint=>List) ListedNfts;
uint[] Listedtokensid;
uint count=0;
function ListNft(uint _price,uint _tokenid) public {
    require(_price>0,"price cannot be 0");
    require(Nft_contract.ownerOf(_tokenid)==msg.sender,"You are not the owner");
    Nft_contract.transferFrom(msg.sender,address(this),_tokenid);
    ListedNfts[_tokenid] = List({
        id:_tokenid,
        sold:false,
        price:_price,
        seller:msg.sender
    });
    Listedtokensid.push(_tokenid);
    
   
  count++;

}

function viewListedNfts() public view returns(List[] memory)   
{

 
 uint unsold=0;
 for(uint i=0;i<count;i++)
 {
    uint index=Listedtokensid[i];
    if(!ListedNfts[index].sold)
    {
        unsold++;
    }
 }
 List[] memory allnfts=new List[](unsold);
 uint curr=0;
    for(uint j=0;j<count;j++)
    {
        uint index=Listedtokensid[j];
        if(!ListedNfts[index].sold)
        {
        allnfts[curr]=ListedNfts[index];
        curr++;
    }
    }
    
    return allnfts;

}
mapping (address=>uint[]) purchased_nft;
uint[] allsoldnfts;

function NFT_purchase(uint listed_nftid) public {
   List storage NFT=ListedNfts[listed_nftid];

   require(!NFT.sold,"NFT already sold once");

   require(token.transferFrom(msg.sender,NFT.seller,NFT.price ),"Token transfer failed");
   
   Nft_contract.transferFrom(address(this),msg.sender, NFT.id);

   NFT.sold=true;
   purchased_nft[msg.sender].push(NFT.id);
   allsoldnfts.push(NFT.id);
 
}

function get_all_sold_nfts() public view returns(uint[] memory){
    require(allsoldnfts.length>0,"NO NFT SOLD");
    return allsoldnfts;
}

function Get_soldnftbyid(address _owner) public view returns(uint[] memory){
    require(_owner!=address(0),"INVALID");
    return purchased_nft[_owner];
    
}

}
