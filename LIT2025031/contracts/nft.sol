// SPDX-License-Identifier: MIT

pragma solidity ^0.8.31;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Minting is ERC721,Ownable{

  constructor() ERC721("NFTTOKEN","Nft") Ownable(msg.sender){
    
  }
       uint256 private no_of_nfts=0;
       struct Nft_data{
        uint nft_id;
        string description;
        string name;
       }
       mapping (uint=> Nft_data) Nfts;
         
       
       function NFTminting(string memory _name,string memory _description) external onlyOwner  returns (uint) {
      
        uint  current_nft_id=no_of_nfts;
        _safeMint(msg.sender, current_nft_id);
         Nfts[current_nft_id].nft_id=current_nft_id;
         Nfts[current_nft_id].name=_name;
         Nfts[current_nft_id].description=_description;
        
        
        no_of_nfts++;
        return current_nft_id;
}


function GetNft(uint _id) public view returns (Nft_data memory){
      require(_id<no_of_nfts,"This token does not exist");

   return Nfts[_id];
}


function getAllNfts() public view returns (Nft_data[] memory){
    
    Nft_data[] memory allnfts=new Nft_data[](no_of_nfts);
    for(uint i=0;i<no_of_nfts;i++)
    {
        allnfts[i]=Nfts[i];
    }
    
    return allnfts;
}


}





