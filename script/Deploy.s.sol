// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/Implementation.sol";
import "../src/DeployProxy.sol";
import {ContractCalls} from "./calls.sol";

contract Deploy is Script {
    UUPSProxy public proxy;

    Implementation public impl;
    ImplementationV2 public impl2;

    function run() public {
        // private key for deployment
        uint256 pk = vm.envUint("PRIVATE_KEY");
        console.log("Deploying contracts with address", vm.addr(pk));

        vm.startBroadcast(pk);

        // Try to load existing addresses from env
        address implAddr = vm.envOr("IMPL_ADDRESS", address(0));
        address implAddr2 = vm.envOr("IMPL2_ADDRESS", address(0));

        address proxyAddr = vm.envOr("PROXY_ADDRESS", address(0));

        if (implAddr == address(0) || proxyAddr == address(0)) {
            console.log(
                "No existing deployment found deploying new version..."
            );
            _initialDeploy();
        } else {
            _useExisting(implAddr, proxyAddr);
        }

        ContractCalls._initializeImplementation(address(proxy), vm.addr(pk));

        if (implAddr2 == address(0)) {
            _deployNewImplementation();
        } else {
            impl2 = ImplementationV2(implAddr2);
        }

        vm.stopBroadcast();

        console.log("Contracts deployed");
    }

    function _useExisting(address implAddr, address proxyAddr) internal {
        impl = Implementation(implAddr);
        proxy = UUPSProxy(payable(proxyAddr));
    }

    // Deploy logic and proxy contract
    function _initialDeploy() internal {
        // deploy logic contract
        impl = new Implementation();
        console.log("New Implementation deployed at:", address(impl));
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(impl), "");
        console.log("New Proxy deployed at:", address(proxy));
    }

    function _deployNewImplementation() internal {
        // deploy new logic contract
        impl2 = new ImplementationV2();
        console.log("New ImplementationV2 deployed at:", address(impl2));
    }
}
