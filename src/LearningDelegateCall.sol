// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Proxy} from "@openzeppelin/contracts/proxy/Proxy.sol";

contract PetiteProxy is Proxy {
    // This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1
    bytes32 private constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    // changes where delegate calls are going to be sending
    // equivalent to upgrading a smart contract
    function setImplementation(address newImplementation) public {
        assembly {
            // avoid Yul as much as possible
            sstore(_IMPLEMENTATION_SLOT, newImplementation)
        }
    }

    // reads where the contract implementation is located
    function _implementation() internal view override returns (address implementationAddress) {
        assembly {
            implementationAddress := sload(_IMPLEMENTATION_SLOT)
        }
    }

    function getDataToTransact(uint256 numberToUpdate) public pure returns (bytes memory) {
        return abi.encodeWithSignature("setValue(uint256)", numberToUpdate);
    }

    function readStorage() public view returns (uint256 valueAtStorageSlotZero) {
        assembly {
            valueAtStorageSlotZero := sload(0)
        }
    }
}

contract ImplementationZ {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}

contract ImplementationY {
    uint256 public value;

    function setValue(uint256 newValue) public {
        value = newValue + 33;
    }
}
