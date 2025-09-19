// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {UUPSProxy} from "../src/DeployProxy.sol";
import {Implementation} from "../src/Implementation.sol";
import {ImplementationV2} from "../src/Implementation.sol";

contract Upgrade is Script {
    UUPSProxy public proxy;
    Implementation public impl;
    ImplementationV2 public impl2;

    function run() public {
        // private key for deployment
        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);
        proxy = UUPSProxy(payable(vm.envAddress("PROXY_ADDRESS")));
        impl = Implementation(vm.envAddress("IMPL_ADDRESS"));
        address impl2Addr = vm.envAddress("IMPL2_ADDRESS");
        if (impl2Addr == address(0)) {
            impl2 = new ImplementationV2();
            console.log("Deployed new ImplementationV2 at:", address(impl2));
        } else {
            impl2 = ImplementationV2(impl2Addr);
        }

        _upradeImplementation();

        vm.stopBroadcast();

        console.log("Contracts upgraded");
    }

    // Upgrade logic contract
    function _upradeImplementation() internal {
        // deploy new logic contract
        // update proxy to new implementation contract
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(impl2),
                bytes("")
            )
        );
        console.log(
            "Did Successfully upgraded implementation contract",
            success
        );
        console.logBytes(data);
    }
}
