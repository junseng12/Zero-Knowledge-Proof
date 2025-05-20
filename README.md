# 🧬 Zero-Knowledge-Proof Circom Practice Suite

This repository contains systematic and practice-oriented learning records on **Circom and ZKP systems**.
It is designed to deeply understand **privacy-preserving circuit design**, from arithmetic operations to Merkle trees, DID authentication, etc.

---

## 🔐 What is Zero-Knowledge Proof (ZKP)?

<img src=".\Images\Zero-Knowledge-Proof-Concept.PNG" width="600px" height="400px">

\*\*Zero-Knowledge Proof (ZKP)\*\* is a cryptographic technique that allows one party (the prover) to prove to the other party (the verifier) ​​that they know certain information without directly revealing that information.

### 🚩 ZKP Use-Cases

- **ZK-DID**: Credential verification without revealing user identity
- **ZK-Rollups**: Hide and verify transaction details on Layer-2 blockchains
- **ZK-Bridge**: Protect sensitive asset ownership and cross-chain communication

### ✨ Intuition Example:

> "Without telling the secret door password,
> you can open the door, come back, and convince the other party that you know the secret."

### 🧱 Types of ZKPs

| Type             | Characteristics                                                  | Typical Use Cases          |
| ---------------- | ---------------------------------------------------------------- | -------------------------- |
| **zk-SNARKs**    | Efficient short proofs, requires trusted setup                   | zkSync, Aztec, Zcash, etc. |
| **zk-STARKs**    | Transparent setup, post-quantum security, increased proof length | StarkWare-based systems    |
| **Bulletproofs** | Short proof, no trusted setup required                           | Confidential Tx            |

---

## 🧠 Why This Repository?

- Understanding the working principle of ZKP in real systems (ZK-DID, ZKBridge)
- Building a reusable Circom circuit library applicable to practice
- Connecting blockchain privacy research interests to practical circuit design

---

## 🧭 Directory Structure

```bash
Zero-Knowledge-Proof/
├── 01-Circom-Basics/
│ ├── Sum.circom, Max.circom, ...
├── 01-Circom-Basics-Hardhat/
│ └── Verifier.sol (Hardhat integration practice)
├── 01-Circom-Practices/
│ └── Intermediate circuits (SumAndCompare, ArrayEqual, etc.)
├── 02-Circom-Withdraw-Limit/
│ ├── WithdrawProof.circom, WithdrawLimit.circom, ...
├── 03-MerkleProof/
│ └── Merkle Inclusion Circuit
├── 03-MerkleUpdate/
│ └── Merkle Path Update Circuit
├── 04-ZKDIDVerify/
│ └── DID Authentication Circuit
├── circom/ (Circom Source for Build)
├── KR/
│ └── README-KR.md
├── README.md
└── README-for-Developer.md
```

---

## 📂 Practice Flow and Structure

| Step         | Folder                     | Summary                                                                |
| ------------ | -------------------------- | ---------------------------------------------------------------------- |
| 🔹 Step 1    | `01-Circom-*`              | Design basic arithmetic/comparison circuits (signal, comparator, etc.) |
| 🔸 Step 2    | `02-Circom-Withdraw-Limit` | Condition-based circuits (LessThan, conditional control logic)         |
| 🔷 Step 3    | `03-Merkle*`               | Merkle tree-based structure (Merkle proof, update)                     |
| 🔐 Step 4    | `04-ZKDIDVerify`           | Design DID authentication circuits (Merkle + Hash logic)               |
| ⚙️ Auxiliary | `circom/`                  | Circom source (for build and maintenance)                              |

---

## 🔄 Standardized Folder Contents

Each folder contains the following files:

- `circuit.circom`: Circom circuit code
- `input.json`: Example input
- `proof.json`: Generated proof
- `verifier.sol`: Solidity verification code (if needed)

---

## 🔬 Key Theoretical Highlights

- **LessThan + IsEqual**: Conditional constraint (used in WithdrawLimit)
- **MerkleProof**: Verifies whether hashed data is included in Merkle Root
- **ArrayEqual + SumAndCompare**: Implements batch comparison logic

---

## 📚 Future Expansion (Research-Oriented Roadmap)

### 1️⃣ **ZK-DID v2: Anonymous Access with Revocation**

- **Anonymous Login**, **Selective Disclosure**, **Credential Revocation**
- Long-term privacy protection and reputation management system

### 2️⃣ **ZKBridge: Cross-Chain State Commitment**

- **Off-chain Proof Generation**, **On-chain Verification**
- Solving trust and delay issues in cross-chain data synchronization

### 3️⃣ **Recursive zkRollup Circuit Simulator**

- **Proof Aggregation**, **Recursive Proof Chaining**
- Improving the scalability of Rollups using recursive proofs

### 4️⃣ **ZK-SmartContract Auditor**

- **Bytecode Analysis**, **Vulnerability Detection without Revealing Code**
- Privacy-guaranteed on-chain security audit system for smart contracts

### 5️⃣ **Privacy-Aware Reputation System**

- **Threshold ZK-Proofs**, **Merkle Tree Dynamic Updates**
- Maintaining privacy while managing user reputation System Build

---

📎 [한국어 문서 보기](./KR/README-KR.md)  
📎 [실행 중심 문서 보기 (for developers)](./README-for-Developer.md)
