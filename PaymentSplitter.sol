// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol";

contract PAYMENTS is PaymentSplitter {
    
    constructor (address[] memory _payees, uint256[] memory _shares) PaymentSplitter(_payees, _shares) payable {}
    
}
// Example of Wallets and Distribution 
/**
 ["0xB97373d8D7Df23722c5aE469e76c6b7308617f4d", 
 "0x2133EB85605006Ca1C534E365e097c6C796b3089",
 "0xe97fec832c067Ee5508AEb9a5a42ee8EF32048EB",
 "0x794fe08Bc540E4FcdF04fffa76872855688f167f"]
 */
 
 // Physical Project 
 // Mintin / Metaverse
 // Marketing 
 // Treasury 
 /**
[85,5,5,5]     
 */