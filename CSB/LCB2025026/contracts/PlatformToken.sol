// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20{
    uint256 public constant RATE = 100000;

    constructor() ERC20("PLatform Token", "PTK"){}

    function buyTokens() external payable{
        require(msg.value>0, "Send ETH");
        _mint(msg.sender, msg.value * RATE);
    }

    function balanceOfUser(address user)external view returns (uint256){
        return balanceOf(user);
    }
}
