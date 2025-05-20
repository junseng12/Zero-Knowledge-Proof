# 🛠 ZK-SNARK Circom Hands-on (with Hardhat Integration)

This repo covers the entire ZK-SNARK flow from Circom circuit design to Solidity smart contract integration, with a particular focus on Groth16-based proof generation and verification.

---

## 🔍 Practice Objectives

- **ZK circuit design** with Circom
- **Witness, proof generation and verification** with SnarkJS
- **Hardhat test success** after Solidity `verifier.sol` integration
- **Acquire practical understanding of ZK flow**

---

## 🧱 Folder structure

```
Zero-Knowledge-Proof/
├── 1-Circom-Basics/ # Circom circuit design, proof generation
├── 1-Circom-Basics-Hardhat/ # Hardhat integration test environment
├── proof/ # proof.json / public.json
├── build/ # wasm, r1cs, witness, zkey
├── contracts/Verifier.sol # Solidity verifier
├── test/verifier.test.js # Hardhat test code
└── README.md
```

---

## 🔄 Summary of the entire flow (concept + practice)

```plaintext
1. Circuit design (WithdrawProof.circom)
2. Circuit compilation → .r1cs, .wasm, .sym
3. Powers of Tau Ceremony → .ptau
4. Trusted Setup (Groth16) → .zkey
5. Input preparation → withdraw_input.json
6. Create witness.wtns
7. Create zk-SNARK proof (.proof.json, .public.json)
8. Create Solidity Verifier.sol
9. Hardhat test integration
```

---

## 🧠 Important concepts when integrating

- `publicSignals` includes the output of the Circom circuit → `isValid` must be included
- `pi_b` coordinates are entered in the order of `(y, x)` in Solidity
- Solidity `verifyProof()` expects exactly `4 inputs` (including isValid)

---

## ✅ Final result

- `snarkjs groth16 verify ...` → `OK!` output
- `npx hardhat test` → `✔ should verify valid proof`

---

## 📦 Technology Stack

- Circom v0.5.46
- snarkjs v0.7.5
- Solidity ^0.8.28
- Hardhat ^2.x

---

## 📁 Other Documents

- `DEBUG.md`: Errors that occurred during integration and the process of solving them
- `README.md`: Concept organization centered on theory/analogy

---

## ✍️ Contributor

Lee Jun-seung — Cybersecurity @ Ajou University
Practice goal: Designing a safe infrastructure for people
