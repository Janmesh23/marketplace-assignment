// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PlatformToken is ERC20 {

    uint256 public rate = 100000;

    constructor() ERC20("Marketplace Token", "MPT") {}

    function buyTokens() public payable {
        require(msg.value > 0);
        uint256 amt = msg.value * rate;
        _mint(msg.sender, amt);
    }

    function bal(address u) public view returns(uint256) {
        return balanceOf(u);
    }
}
