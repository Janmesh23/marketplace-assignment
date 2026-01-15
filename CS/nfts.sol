// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract creatingnfts {

uint256 public totalnfts;

struct NFTDATA {
   string name ;
   string description;
   string[3] trait_type;
   string[3] value;
   address owner;
}
// "NFT1", "desc", ["t1","t2","t3"], ["v1","v2","v3"]
mapping (uint256 => NFTDATA) public nfts; 

 function mintnft(
        string memory _name,
        string memory _description,
        string[3] memory _trait_type,
        string[3] memory _value
    ) public {
        totalnfts++;
        nfts[totalnfts] = NFTDATA(_name, _description, _trait_type, _value, msg.sender);
    }
function transferNFT(uint256 _id, address newOwner) external {
    require(nfts[_id].owner == msg.sender, "Not owner");
    nfts[_id].owner = newOwner;
}

    function getnft (uint256 _id) public view returns (NFTDATA memory) {

        return nfts[_id];


    }

    function getallnfts () public view returns (NFTDATA[] memory) {

    NFTDATA[] memory arr = new NFTDATA[](totalnfts);
       for(uint256 i = 1; i <= totalnfts; i++){
            arr[i-1] = nfts[i];
        }
return arr;


    }


}