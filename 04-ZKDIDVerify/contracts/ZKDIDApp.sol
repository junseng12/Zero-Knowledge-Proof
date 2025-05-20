// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Verifier.sol";

contract ZKDIDApp {
    Verifier public verifier;

    event Authorized(address indexed user);

    constructor(address _verifierAddress) {
        verifier = Verifier(_verifierAddress);
    }

    function authenticate(
      uint[2] memory a,
      uint[2][2] memory b,
      uint[2] memory c,
      uint[1] memory input
    ) public returns (bool) {
        bool verified = verifier.verifyProof(a, b, c, input);
        require(verified, "Invalid ZK proof");

        emit Authorized(msg.sender);
        return true;
    }
}