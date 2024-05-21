// SPDX-License-Identifier: CSI
pragma solidity ^0.8.0;

import "./ISunContract.sol";

contract MoonContract {
    string public riddle;
    address public alchemist;
    ISunContract public sun_contract;

    mapping(string => string) private transmute;

    constructor() {
        alchemist = msg.sender;
    }

    modifier onlyAlchemist() {
        require(msg.sender == alchemist, "You shall not pass!");
        _;
    }

    function init(address _sun_contract, string memory _riddle) public onlyAlchemist {
        sun_contract = ISunContract(_sun_contract);
        riddle = _riddle;
    }

    function transmute_many(string[] memory first_matters, string[] memory great_works) public onlyAlchemist {
        require(first_matters.length == great_works.length, "Arrays must have the same length");
        for (uint256 i = 0; i < first_matters.length; i++) {
            transmute[first_matters[i]] = great_works[i];
        }
    }

    function reveal(string memory answer) public view returns (string memory) {
        string memory sun_output = sun_contract.transmute(answer);
        return transmute[sun_output];
    }
}