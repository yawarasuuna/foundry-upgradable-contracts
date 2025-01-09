// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Script} from "forge-std/Script.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract DeployBox is Script {
    function run() external returns (address) {
        address proxy = deployBox();
        return proxy;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast();
        BoxV1 box = new BoxV1(); // implementation logic where proxies point to delegatecall to borrow those functions
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
