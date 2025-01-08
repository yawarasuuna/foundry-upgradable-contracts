// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {console2, Test} from "forge-std/Test.sol";
import {Script} from "forge-std/Script.sol";
import {DeployBox} from "../../script/DeployBox.s.sol";
import {UpgradeBox} from "../../script/UpgradeBox.s.sol";
import {BoxV1} from "../../src/BoxV1.sol";
import {BoxV2} from "../../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;

    address public proxy;
    address public OWNER = makeAddr("owner");

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run(); // proxy is currently pointing to BoxV1
    }

    function testProxyStartsAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(42);
    }

    function testContractUpgradesToBoxV2() public {
        BoxV2 boxV2 = new BoxV2();

        upgrader.upgradeBox(proxy, address(boxV2));
        uint256 expectedVersion = 2;

        assertEq(expectedVersion, BoxV2(proxy).version());

        BoxV2(proxy).setNumber(42);
        assertEq(42, BoxV2(proxy).getNumber());
    }
}
