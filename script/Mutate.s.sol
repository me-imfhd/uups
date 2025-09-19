// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {UUPSProxy} from "../src/DeployProxy.sol";
import {Implementation} from "../src/Implementation.sol";
import {ImplementationV2} from "../src/Implementation.sol";
import {ContractCalls} from "./calls.sol";

contract Mutate is Script {
    UUPSProxy public proxy;
    Implementation public impl;
    ImplementationV2 public impl2;

    function run() public {
        // private key for deployment
        uint256 pk = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(pk);
        proxy = UUPSProxy(payable(vm.envAddress("PROXY_ADDRESS")));
        impl = Implementation(vm.envAddress("IMPL_ADDRESS"));
        impl2 = ImplementationV2(vm.envAddress("IMPL2_ADDRESS"));

        ContractCalls._setMagicStringImpl2(address(proxy));

        vm.stopBroadcast();
    }
}
