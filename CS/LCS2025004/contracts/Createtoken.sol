// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20 {

    uint256 public constant tokenspereth= 100000; 

    constructor() ERC20("Custom Token", "TKN") {}

    function mintTokens() external payable {
        require(msg.value > 0, "Increase ETH");

        uint256 amount = msg.value * tokenspereth;
        _mint(msg.sender, amount);
    }

    function checkbalance(address user) external view returns (uint256) {
        return balanceOf(user);
    }
}
