
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract platform_token is ERC20 {
    address payable public owner;
    uint256 public constant token_1_ETH = 100000;
    uint256 public constant min_ETH = 0.00001 ether;
    constructor() ERC20("platform_token", "pft") {
        owner = payable(msg.sender);
    }
    function mint() public payable {
        require(msg.value >= min_ETH, "Minimum amount is 0.00001 ETH");
        uint256 amountToMint = (msg.value * token_1_ETH * (10**decimals())) / 1 ether;
        _mint(msg.sender, amountToMint);
        
        (bool success,) = owner.call{value: msg.value}("");
        require(success, "Transfer to owner failed");
    }
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }   
}