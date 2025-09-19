// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/Implementation.sol";
import "../src/DeployProxy.sol";

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
        address proxyAddr = vm.envOr("PROXY_ADDRESS", address(0));
        address impl2Addr = vm.envOr("IMPL2_ADDRESS", address(0));

        if (implAddr == address(0) || proxyAddr == address(0)) {
            console.log(
                "No existing deployment found deploying new version..."
            );
            _initialDeploy();
        } else {
            console.log("Found existing addresses reusing...");
            _useExisting(implAddr, proxyAddr, impl2Addr);
            // _initializeImplementation();
            _setMagicNumberImpl1();
            // _deployNewImplementation();
            // _upradeImplementation();
            _setMagicStringImpl2();
        }

        vm.stopBroadcast();

        console.log("Contracts deployed");
    }

    function _useExisting(
        address implAddr,
        address proxyAddr,
        address impl2Addr
    ) internal {
        impl = Implementation(implAddr);
        proxy = UUPSProxy(payable(proxyAddr));
        impl2 = ImplementationV2(impl2Addr);
        console.log("Using existing Implementation:", address(impl));
        console.log("Using existing Proxy:", address(proxy));
        console.log("Using existing ImplementationV2:", address(impl2));
    }

    // Deploy logic and proxy contract
    function _initialDeploy() internal {
        // deploy logic contract
        impl = new Implementation();
        console.log(address(impl));
        // deploy proxy contract and point it to implementation
        proxy = new UUPSProxy(address(impl), "");
        console.log(address(proxy));
    }

    function _initializeImplementation() internal {
        // initialize implementation contract
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("initialize(address)", msg.sender)
        );
        console.log(
            "Did Successfully initialized implementation contract",
            success
        );
        console.logBytes(data);
    }

    function _setMagicNumberImpl1() internal {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("setMagicNumber(uint256)", 123456789)
        );
        console.log("Did Successfully set magic number", success);
        console.logBytes(data);
    }

    function _setMagicStringImpl2() internal {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature(
                "setMagicString(string)",
                "Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal"
            )
        );
        console.log("Did Successfully set magic string", success);
        console.logBytes(data);
    }

    function _deployNewImplementation() internal {
        // deploy new logic contract
        impl2 = new ImplementationV2();
        console.log(address(impl2));
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
