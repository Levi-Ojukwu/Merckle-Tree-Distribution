// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "../lib/solmate/src/utils/MerkleProofLib.sol";
import "../lib/solmate/src/tokens/ERC1155.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Merkle is ERC1155 {
    bytes32 root;

    constructor(bytes32 _root) {
        root = _root;
    }

    mapping(address => bool) public hasClaimed;

    function claim(
        address _claimer,
        uint _amount,
        uint _id,
        bytes32[] calldata _proof
    ) external returns (bool success) {
        require(!hasClaimed[_claimer], "already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(_claimer, _amount));
        bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
        require(verificationStatus, "not whitelisted");
        hasClaimed[_claimer] = true;
        _mint(_claimer, _amount, _id, bytes32 memory _data);
        success = true;
    }
}
