// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Factory} from "../src/Factory.sol";
import {Script, console2} from "forge-std/Script.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        address addr;
        string memory salt = vm.envString("SALT");

        bytes memory initCode = type(Factory).creationCode;

        assembly {
            addr := create2(0, add(initCode, 0x20), mload(initCode), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        console2.log("created Factory:", addr);
        console2.log("salt:", salt);
    }
}
