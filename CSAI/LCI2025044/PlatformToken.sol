// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20 {

    uint256 public constant TOKENS_PER_ETH = 100000;

    constructor() ERC20("Platform Token", "PTK") {}

   
    function mintTokens() external payable {
        require(msg.value > 0, "Please send ETH");

        uint256 tokensToMint = msg.value * TOKENS_PER_ETH;
        _mint(msg.sender, tokensToMint);
    }


    function checkBalance(address user) external view returns (uint256) {
        return balanceOf(user);
    }
}
