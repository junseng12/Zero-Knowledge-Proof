// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
// import "hardhat/console.sol";

interface IVerifier {
    function verifyProof(
        uint[2] calldata a,
        uint[2][2] calldata b,
        uint[2] calldata c,
        uint[1] calldata input
    ) external view returns (bool);
}

contract ZKRoleVerifyApp {
    IVerifier public verifier;

    event Authorized(address indexed user);

    constructor(address _verifier) {
        verifier = IVerifier(_verifier);
    }

    function authenticate(
        uint[2] calldata a,
        uint[2][2] calldata b,
        uint[2] calldata c,
        uint[1] calldata input
    ) external {
        bool verified = verifier.verifyProof(a, b, c, input);
        // console.log("Proof verified:", verified);
        require(verified, "Invalid ZK proof");

        emit Authorized(msg.sender);
    }
}
