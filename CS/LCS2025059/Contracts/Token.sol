// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MarketToken is ERC20 {
    //rate ko 1lakh rkhna h
    uint public constant rate = 100000;

    constructor() ERC20("Market Token", "MTN") {}

   
    function mintTokens() external payable {
        require(msg.value > 0, "Enter a valid amount");

        uint256 tokenAmount = msg.value * rate;

        _mint(msg.sender, tokenAmount);
    }

    function getBalance(address user) external view returns (uint) {
        return balanceOf(user);
    }
}
