// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

import "forge-std/console.sol";

library ContractCalls {
    function _initializeImplementation(
        address proxy,
        address initalOwner
    ) internal {
        // initialize implementation contract
        console.log(
            "Initializing implementation contract with owner",
            initalOwner
        );
        console.log("Proxy address", proxy);
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("initialize(address)", initalOwner)
        );
        console.log(
            "Did Successfully initialized implementation contract",
            success
        );
        console.logBytes(data);
    }

    function _setMagicNumberImpl1(address proxy) internal {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature("setMagicNumber(uint256)", 123456789)
        );
        console.log("Did Successfully set magic number", success);
        console.logBytes(data);
    }

    function _setMagicStringImpl2(address proxy) internal {
        (bool success, bytes memory data) = address(proxy).call(
            abi.encodeWithSignature(
                "setMagicString(string)",
                "Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal, Ab kare so aaj kar, aaj kare so kal"
            )
        );
        console.log("Did Successfully set magic string", success);
        console.logBytes(data);
    }
}
