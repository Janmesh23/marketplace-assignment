// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface INFT {
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function NFTexists(uint256 tokenId) external view returns (bool);
}
