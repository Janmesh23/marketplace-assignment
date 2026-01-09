// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    =========================================================
    ERC20 CONTRACT FOR BUYING ABIR'S TOKEN USING SEPOLIA ETH
    =========================================================

    FEATURES:
    - ERC20 
    - User minting
    - Easy frontend listing
    - Events for indexing

*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract TOKENexchange is ERC20, Ownable {


    

    // 🔔 Event for frontend / backend indexing
    event TokensBought(
        uint256 indexed amount,
        address indexed owner
    );

    constructor()
        ERC20("Abir'sToken", "ABIR")
        Ownable(msg.sender)
    {}


    /*
        =====================================================
                CHECK TOKEN BALANCE OF USER
        =====================================================
    */

    function checkBalance(address user) external view returns (uint256) {
    return balanceOf(user)/1000000000000000000;
    }


    /*
        =====================================================
                 TOKEN  BUY USING SEPOLIA ETH
        =====================================================
    */

    function tokenbuy() public payable{
        require((msg.sender).balance>=msg.value,"Your account doesn't have sufficient balance"); 
        uint256  amount = msg.value*100000;
        _mint(msg.sender, amount);
        emit TokensBought( amount,msg.sender);
    }

    
   
    /*
        =====================================================
                     WITHDRAW FUNCTION
        =====================================================
    */

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance>0, "No ETH to withdraw");
        payable (owner()).transfer(balance);
    }
    
    
}