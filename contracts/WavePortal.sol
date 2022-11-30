// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    uint private seed;

    event NewWave (address indexed from , uint256 timestamp,string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;
    constructor() payable {
        console.log("We have been constructed!");

        /** seet intial seed */

        seed =(block.timestamp + block.difficulty)%100;
    }

    function wave(string memory _message) public{

        require(
            lastWavedAt[msg.sender]+10 seconds < block.timestamp, "Wait 10 seconds"
        );

        lastWavedAt[msg.sender] = block.timestamp;


        totalWaves +=1;
        console.log("%s has waved",msg.sender,_message);

        waves.push(Wave(msg.sender,_message,block.timestamp));


        /* Generate a new seed for the next user send a wave*/

        seed = (block.difficulty+block.timestamp)%100;

        console.log("Random  # generate : %d",seed);
        
        /*
         * Give a 50% chance that the user wins the prize.
         */
        if(seed < 50){
            console.log("%s won! ", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
        
            require(prizeAmount <= address(this).balance,"Trying to withdraw more money than the contract has." );

            (bool success,) = (msg.sender).call{value: prizeAmount}("");
             require(success,"Failed to withdraw money from contract. ");

        }
        
        emit NewWave(msg.sender, block.timestamp, _message);   
    }
    
    /*
     * I added a function getAllWaves which will return the struct array, waves, to us.
     * This will make it easy to retrieve the waves from our website!
     */
    function getAllWaves() public view returns (Wave[] memory){
        return waves;
    }
    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
