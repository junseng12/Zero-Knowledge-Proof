# 🧠 ZKP Full Practice Summary (Circom + SnarkJS Based)

---

## 📌 Practice Goals

- Design Circom circuit and implement the entire ZKP flow directly using SnarkJS
- Link with Verifier in Solidity to perform ZK verification in smart contracts

---

## 🔸 Summary of ZKP Core Concepts

### ✅ What is ZKP (Zero-Knowledge Proof)?

- A method that **proves** only the **fact** of knowing the **private input** without directly disclosing any **secret information**
- Applications in various areas such as privacy protection, state proof, and L1-L2 bridge in blockchain

### ✅ 3 stages of Groth16-based ZKP

1. **Setup**

- Convert circuit (.circom) to R1CS format
- Generate common setting value (PTAU) + circuit-based ZKey file

2. **Prove**

- Generate witness with input (input.json)
- Generate proof based on witness + ZKey

3. **Verify**

- Verifier verifies proof and public input (public) to determine authenticity

---

## 🔸 Entire flow from Circom → Solidity

```mermaid
flowchart TD
A[Write WithdrawProof.circom] --> B[Compile Circom (.r1cs, .wasm)]
B --> C[Generate or download ptau]
C --> D[Create zkey initial file (0000.zkey)]
D --> E[Contribute prover (final.zkey)]
E --> F[Create Solidity Verifier (verifier.sol)]
F --> G[Write input (withdraw_input.json)]
G --> H[Create Witness]
H --> I[Create Proof (proof.json, public.json)]
I --> J[Send proof to Verifier and verify]

```

---

## 🔸 Summary of command flow during practice

### ✅ Compile Circom circuit

```bash
circom circuits/WithdrawProof.circom --r1cs --wasm --sym -o build/
```

### ✅ Set Powers of Tau

```bash
snarkjs powersoftau new bn128 14 pot14_0000.ptau
snarkjs powersoftau contribute pot14_0000.ptau pot14_final.ptau --name="junseung"
snarkjs powersoftau prepare phase2 pot14_final.ptau pot14_final_phase2.ptau
```

### ✅ Generate zkey

```bash
snarkjs groth16 setup build/WithdrawProof.r1cs build/pot14_final_phase2.ptau build/withdrawproof_0000.zkey
snarkjs zkey contribute build/withdrawproof_0000.zkey build/withdrawproof_final.zkey --name="junseung"
snarkjs zkey export solidityverifier build/withdrawproof_final.zkey contracts/Verifier.sol
```

### ✅ Input and proof

```bash
snarkjs wtns calculate build/WithdrawProof.wasm inputs/withdraw_input.json build/witness.wtns
snarkjs groth16 prove build/withdrawproof_final.zkey build/witness.wtns proof/proof.json proof/public.json
```

### ✅ Verification

```bash
snarkjs zkey export verificationkey build/withdrawproof_final.zkey build/verification_key.json
snarkjs groth16 verify build/verification_key.json proof/public.json proof/proof.json
```

---

## 🔸 Core Concepts Metaphors

| Elements           | Roles                                 | Metaphors                                                 |
| ------------------ | ------------------------------------- | --------------------------------------------------------- |
| `.circom` Circuits | Logic of conditions to prove          | Math test questions                                       |
| `.r1cs`            | Mathematical constraints on circuits  | Formulating the correct conditions for the test questions |
| `.ptau`            | Common settings                       | Question bank (Common settings data)                      |
| `.zkey`            | Circuit + proving key made with ptau  | Answer sheet for exam                                     |
| `input.json`       | Actual value of prover                | Answers I wrote for exam                                  |
| `witness.wtns`     | Calculation of condition satisfaction | Automatic grading result                                  |
| `proof.json`       | Data proving condition satisfaction   | Exam answer certificate                                   |
| `public.json`      | Public input                          | Premise information disclosed in the problem itself       |
| `verifier.sol`     | Proof verification in smart contract  | Grading program                                           |

---

## 🔸 Key points that were often confused

- The internal array order of `pi_b` needs to be changed → Adjusted to `[y, x]` → `[x, y]`
- `public.json` only contains information that should be public among the `signal inputs` of the Circom circuit
- Solidity Verifier requires a **very strict format** such as `uint[2]`, `uint[2][2]`, `uint[4]`
- **Public input order** in `verifyProof()` must be 100% identical to the circuit definition

---

## ✅ What has been completed so far

- Circom circuit design and compilation
- Entire Powers of Tau ceremony process
- zkey, Solidity Verifier generation
- Witness and proof generation
- Off-chain verification using SnarkJS **OK**
- Hardhat integration and Solidity verification **Tracking the cause of failure**

---

## 🪜 Next activities Recommended

1. Regenerate `.zkey`, `.ptau`, `verifier.sol` (reset all configurations)
2. Regenerate ZK proof with new `withdraw_input.json`
3. Re-run Hardhat integration (`npx hardhat test`)
4. Practice extending Circom circuit (`withdraw_limit`, `range_check`, etc.)
5. Practice designing ZK-based authentication circuit (simple login, etc.)

---

👉 Feel free to ask questions or need more explanations!
