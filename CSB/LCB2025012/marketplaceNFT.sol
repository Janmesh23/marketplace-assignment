//SPDX-License-Identifier:MIT
pragma solidity^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract marketplaceNFT is ERC721Enumerable {
    constructor() ERC721("myNFT","MFT"){
    }

        struct metadataNFT{
            string NFT_name;
            string NFT_description;
        }
            mapping(uint256 => metadataNFT) private metaData;
            uint private nextTokenID;

            function mintNFT(string memory _NFT_name, string memory _NFT_description) public  {
                uint256 tokenID = nextTokenID++;
                _mint(msg.sender, tokenID);
                metaData[tokenID] = metadataNFT({
                    NFT_name: _NFT_name,
                    NFT_description: _NFT_description

                });
            }    

                    function getmetadataNFT(uint tokenID) public view returns(string memory, string memory){
                        require(_ownerOf(tokenID) != address(0) ,"token does not exist");
                        metadataNFT memory data = metaData[tokenID];
                        return(data.NFT_name, data.NFT_description);

                    }
                        function getMintedNFT() public view returns(uint[] memory){
                            uint total= totalSupply();
                            uint[] memory IDs = new uint[](total);

                            for(uint i=0; i<total; i++){
                                IDs[i]= tokenByIndex(i);
                            }

                            return IDs;

                        }
                        

}