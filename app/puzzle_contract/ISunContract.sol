// SPDX-License-Identifier: CSI
pragma solidity ^0.8.0;

interface ISunContract {
    // Public state variables
    function riddle() external view returns (string memory);
    function alchemist() external view returns (address);
    function transmute(string memory) external view returns (string memory);
    // Functions
    function init(string memory _riddle) external;
    function transmute_many(string[] memory first_matters, string[] memory great_works) external;
}