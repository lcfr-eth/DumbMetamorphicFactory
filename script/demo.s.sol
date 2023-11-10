// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Counter} from "../src/Counter.sol";
import {Factory} from "../src/Factory.sol";

import {Script, console2} from "forge-std/Script.sol";

contract Demo is Script {
    function setUp() public {
        address addr;
        string memory salt = vm.envString("SALT");
        bytes memory factoryCode = type(Factory).creationCode;

        assembly {
            addr := create2(0, add(factoryCode, 0x20), mload(factoryCode), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        console2.log("created Factory:", addr);
        console2.log("salt:", salt);

        Factory factory = Factory(addr);
        bytes memory initCode = type(Counter).creationCode;
        // constructor arguments are abi encoded and appended to the initCode
        bytes memory counterCreateCode = abi.encodePacked(initCode, abi.encode(1337));

        address deployed = factory.deploy(counterCreateCode);
        console2.log("Counter(1337) Address:", deployed);

        Counter counter = Counter(deployed);
        assert(counter.number() == 1337);

        counter.kill();
        factory.kill();
    }

    function run() public {

        address addr;
        string memory salt = vm.envString("SALT");

        bytes memory factoryCode = type(Factory).creationCode;

        assembly {
            addr := create2(0, add(factoryCode, 0x20), mload(factoryCode), salt)
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }

        console2.log("Redeployed Factory:", addr);
        console2.log("salt:", salt);

        Factory factory = Factory(addr);
        bytes memory initCode = type(Counter).creationCode;
        bytes memory counterCreateCode = abi.encodePacked(initCode, abi.encode(1234));

        address deployed = factory.deploy(counterCreateCode);
        console2.log("Counter(1234) Address:", deployed);

        Counter counter = Counter(deployed);
        assert(counter.number() == 1234);

        counter.kill();
        factory.kill();
    }
}