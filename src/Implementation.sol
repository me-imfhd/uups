// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract Implementation is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 magicNumber;

    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
    }

    function setMagicNumber(uint256 newMagicNumber) public {
        magicNumber = newMagicNumber;
    }

    function getMagicNumber() public view returns (uint256) {
        return magicNumber;
    }

    // override from UUPSUpgradeable, added onlyOwner modifier for access control
    function _authorizeUpgrade(address) internal override onlyOwner {}
}

// inherit from previous implementation contract to prevent storage collisions
contract ImplementationV2 is Implementation {
    string magicString;

    function setMagicString(string memory newMagicString) public {
        magicString = newMagicString;
    }

    function getMagicString() public view returns (string memory) {
        return magicString;
    }
}

struct MyStruct {
    uint256 magicNumber;
    string magicString;
}

contract ImplementationV3 is UUPSUpgradeable, OwnableUpgradeable {
    MyStruct myStruct;

    function setMyStruct(
        uint256 newMagicNumber,
        string memory newMagicString
    ) public {
        myStruct = MyStruct(newMagicNumber, newMagicString);
    }

    function getMyStruct() public view returns (uint256, string memory) {
        return (myStruct.magicNumber, myStruct.magicString);
    }

    function _authorizeUpgrade(address) internal view override {
        if (msg.sender != owner()) {
            revert OwnableUnauthorizedAccount(msg.sender);
        }
    }
}

contract ImplementationV4 is UUPSUpgradeable, OwnableUpgradeable {
    /// @notice Store a mapping of address to its MyStruct
    mapping(address => MyStruct) private myStructs;

    /// @notice Set struct for the sender
    function setMyStruct(
        uint256 newMagicNumber,
        string memory newMagicString
    ) public {
        myStructs[msg.sender] = MyStruct(newMagicNumber, newMagicString);
    }

    /// @notice Get struct for the sender
    function getMyStruct()
        public
        view
        returns (uint256, string memory, address)
    {
        MyStruct storage s = myStructs[msg.sender];
        return (s.magicNumber, s.magicString, msg.sender);
    }

    /// @notice Get struct for any address
    function getMyStructOf(
        address account
    ) public view returns (uint256, string memory, address) {
        MyStruct storage s = myStructs[account];
        return (s.magicNumber, s.magicString, account);
    }

    /// @notice Upgrade authorization
    function _authorizeUpgrade(address) internal view override {
        if (msg.sender != owner()) {
            revert OwnableUnauthorizedAccount(msg.sender);
        }
    }
}
