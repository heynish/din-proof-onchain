// SPDX-License-Identifier: CSI

pragma solidity ^0.8.0;
/*
 _______   __   __       __    _______  _______ .__   __.   ______  _______                               
|       \ |  | |  |     |  |  /  _____||   ____||  \ |  |  /      ||   ____|                              
|  .--.  ||  | |  |     |  | |  |  __  |  |__   |   \|  | |  ,----'|  |__                                 
|  |  |  ||  | |  |     |  | |  | |_ | |   __|  |  . `  | |  |     |   __|                                
|  '--'  ||  | |  `----.|  | |  |__| | |  |____ |  |\   | |  `----.|  |____                               
|_______/ |__| |_______||__|  \______| |_______||__| \__|  \______||_______|                              
                                                                                                          
 _______ .___________. __    __  .______    _______ .______       __       __  .__   __.   ___    _  _    
|   ____||           ||  |  |  | |   _  \  |   ____||   _  \     |  |     |  | |  \ |  |  / _ \  | || |   
|  |__   `---|  |----`|  |__|  | |  |_)  | |  |__   |  |_)  |    |  |     |  | |   \|  | | | | | | || |_  
|   __|      |  |     |   __   | |   _  <  |   __|  |      /     |  |     |  | |  . `  | | | | | |__   _| 
|  |____     |  |     |  |  |  | |  |_)  | |  |____ |  |\  \----.|  `----.|  | |  |\   | | |_| |    | |   
|_______|    |__|     |__|  |__| |______/  |_______|| _| `._____||_______||__| |__| \__|  \___/     |_|
                  
          .|,              
         \.',/     
         = , =     
         / | \ 
    /\    "V"
   /__\    I      O  o
  //O o\   I     .
    \_/    I
  /l\/j\  (I]   .  O
 /. ~~ ,\//I          .
 \\L__j^\/ I       o
  \/--v}   I     o   .
  |    |   I   _________
  |    |   I c(`       ')o
  |    l   I   \.     ,/
_/j  L l\_ !  _//^---^\\_   
                                                                                                          
.______       __   _______   _______   __       _______                                                   
|   _  \     |  | |       \ |       \ |  |     |   ____|                                                  
|  |_)  |    |  | |  .--.  ||  .--.  ||  |     |  |__                                                     
|      /     |  | |  |  |  ||  |  |  ||  |     |   __|                                                    
|  |\  \----.|  | |  '--'  ||  '--'  ||  `----.|  |____                                                   
| _| `._____||__| |_______/ |_______/ |_______||_______|                                                  

Find the right passphrase and verify it in this contract to unlock your mint!

Directions:
1. Solve the riddle of the Sun contract.
2. Use transmute() with the answer in the Sun contract.
3. Using the transmuted answer, solve the riddle of the Moon contract.
4. Use reveal() with the answer in the Moon contract.
5. Get the passphrase by combining the answer to the riddle of the Moon contract with its reveal.
6. Verify the passphrase with verify_secret() of this contract.
7. Mint!

*/
contract MagnumOpus {
    
    address public alchemist;
    bytes32 public secret_hash;
    address public sun_contract;
    address public moon_contract;
    string public riddle;

    constructor(){
      alchemist=msg.sender;
    }

    modifier onlyAlchemist() {
        require(msg.sender == alchemist, "You shall not pass!");
        _;
    }

    function init(bytes32 _secret_hash, address _sun, address _moon, string memory _riddle) public onlyAlchemist {
        secret_hash=_secret_hash;
        sun_contract=_sun;
        moon_contract=_moon;
        riddle=_riddle;
    }

    function verify_secret(string memory _secret) public view returns (bool) {
        bytes32 provided_hash = keccak256(abi.encodePacked(_secret));
        return (provided_hash==secret_hash);
    }   
}