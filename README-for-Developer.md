## 📙 README-for-Developer.md 초안 구조

````markdown
# 🛠️ Developer Guide: ZKP Practice Circom Projects

## 📦 Installation

```bash
# Install circom
git clone https://github.com/iden3/circom.git
cd circom && cargo build --release

# Install snarkjs
npm install -g snarkjs
```
````

## 🚀 How to Run (Example for WithdrawLimit)

```bash
# Compile circuit
circom WithdrawLimit.circom --r1cs --wasm --sym

# Generate witness
node WithdrawLimit_js/generate_witness.js WithdrawLimit_js/WithdrawLimit.wasm input.json witness.wtns

# Setup (Powers of Tau → Phase 2)
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_final.ptau --name="First contribution"
snarkjs powersoftau prepare phase2 pot12_final.ptau pot12_final.ptau

# Generate proving key
snarkjs groth16 setup WithdrawLimit.r1cs pot12_final.ptau WithdrawLimit.zkey

# Generate proof
snarkjs groth16 prove WithdrawLimit.zkey witness.wtns proof.json public.json

# Verify
snarkjs groth16 verify verification_key.json public.json proof.json
```

## 🗂️ Folder Guide

| Folder                     | Summary                        |
| -------------------------- | ------------------------------ |
| `01-Circom-Basics`         | Basic arithmetic & comparison  |
| `02-Circom-Withdraw-Limit` | Practical withdraw constraints |
| `03-MerkleProof`           | Merkle inclusion circuit       |
| `04-ZKDIDVerify`           | ZK-DID verification circuit    |
