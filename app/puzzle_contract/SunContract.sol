// SPDX-License-Identifier: CSI
pragma solidity ^0.8.0;

contract SunContract {
    string public riddle;
    address public alchemist;

    mapping(string => string) public transmute;

    constructor() {
        alchemist = msg.sender;
    }

    modifier onlyAlchemist() {
        require(msg.sender == alchemist, "You shall not pass!");
        _;
    }

    function init(string memory _riddle) public onlyAlchemist {
        riddle = _riddle;
    }

    function transmute_many(string[] memory first_matters, string[] memory great_works) public onlyAlchemist {
        require(first_matters.length == great_works.length, "Arrays must have the same length");
        for (uint256 i = 0; i < first_matters.length; i++) {
            transmute[first_matters[i]] = great_works[i];
        }
    }
}