// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Factory {

    function deploy(bytes memory code) public returns (address addr) {
        assembly {
            addr := create(0, add(code, 0x20), mload(code))
            if iszero(extcodesize(addr)) {
                revert(0, 0)
            }
        }
    }

    // destruct the factory contract so we reset the nonce to 0 from the create2 created address using the same salt
    function kill() public {
        selfdestruct(payable(address(0)));
    }

}