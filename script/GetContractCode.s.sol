// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Counter} from "../src/Counter.sol";
import {Script, console2} from "forge-std/Script.sol";

// returns the Counter creation code with the constructor argument encoded

contract GetContractCode is Script {
    function setUp() public {}

    function run() public {

        bytes memory initCode = type(Counter).creationCode;
        // constructor arguments are abi encoded and appended to the initCode
        bytes memory createCode = abi.encodePacked(initCode, abi.encode(1337));

        console2.log("createCode:");
        console2.logBytes(createCode);
    }
}
