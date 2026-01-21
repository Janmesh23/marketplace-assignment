// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {

    struct Info {
        string name;
        string desc;
    }

    uint256 public tot;
    mapping(uint256 => Info) public data;
    uint256[] public allIds;

    constructor() ERC721("OnChainNFT", "OCN") {}

    function mintNFT(string memory n, string memory d) public {
        tot++;
        _mint(msg.sender, tot);
        data[tot] = Info(n, d);
        allIds.push(tot);
    }

    function getNFT(uint256 id) public view returns(string memory, string memory, address) {
        Info memory x = data[id];
        return (x.name, x.desc, ownerOf(id));
    }

    function getAllNFTs() public view returns(uint256[] memory) {
        return allIds;
    }
}
