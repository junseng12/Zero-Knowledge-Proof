# 🔐 Zero-Knowledge Proof Practice Report

## 📘 Overview: Purpose of this Practice

The purpose of this project is to experience the entire process from ZKP circuit design to proof generation and Solidity integration through ZKP (Zero-Knowledge Proof) practice based on Circom and snarkjs.

Through this, we will establish the foundation for practical design such as **ZKBridge, AKP, L2 Rollup, DID authentication structure design**.

---

## 🧠 Theoretical Background

### 1. Zero-Knowledge Proof (ZKP)

- **Prove to the other party that I satisfy a certain condition**, but hide the specific input of the condition. - Components:
- Circuit: Formula expresses the condition to be proven
- Input value: Separate public/private input
- Witness: Circuit execution result
- Proof: Mathematical proof created based on the data above

### 2. L1 ↔ L2 structure

- Layer 1 (L1): Main chain (ex. Ethereum)
- Layer 2 (L2): External network that processes transactions faster and cheaper
- **ZKP-based state proof** plays a key role when reflecting the state processed in L2 to L1

### 3. ZKBridge

- Bridge structure that proves and propagates the state between different blockchains (L1-L2 or cross-chain)
- Components:
- State tree (Merkle Root)
- ZKP circuit (Proof of validity of L2 state change)
- Verifier (L1 smart contract)

---

## ✅ Key elements and analogies of the ZKP system

| Element                 | Description                                                 | Analogy                                            |
| ----------------------- | ----------------------------------------------------------- | -------------------------------------------------- |
| `.circom`               | Writing proof conditions as a circuit                       | Exam question document                             |
| `.r1cs`                 | Constraint system that mathematically expresses the circuit | Commentary on the mathematical formula of the exam |
| `.wasm`                 | Machine code that can execute the circuit                   | Calculator (automatic solving)                     |
| `.ptau`                 | Common security settings                                    | Security rules of the exam room                    |
| `.zkey`                 | Circuit + proof system key made with ptau                   | Problem book + exam criteria                       |
| `input.json`            | Input value definition (including public + private)         | Exam question answer sheet                         |
| `witness.wtns`          | Circuit execution result                                    | Examinee's solution note                           |
| `proof.json`            | Proof compressed in ZK method                               | Unforgeable exam pass certificate                  |
| `public.json`           | Public input for verification                               | Public answer column                               |
| `verification_key.json` | Verification key used by the verifier                       | Grading criteria                                   |
| `verifier.sol`          | On-chain verification smart contract                        | Automatic scoring system                           |

---

## 🔧 Commands and meanings used in practice

| Command                                                     | Description                       |
| ----------------------------------------------------------- | --------------------------------- |
| `circom WithdrawProof.circom --r1cs --wasm --sym -o build/` | Circuit compilation               |
| `snarkjs powersoftau new bn128 14 pot14_0000.ptau`          | Initial ptau creation             |
| `snarkjs powersoftau contribute ...`                        | Randomness contribution           |
| `snarkjs powersoftau prepare phase2 ...`                    | Prepare ptau for the circuit      |
| `snarkjs groth16 setup ...`                                 | Generate zkey with circuit + ptau |
| `snarkjs zkey contribute ...`                               | Generate final proving key        |
| `snarkjs zkey export solidityverifier ...`                  | Create smart contract verifier    |
| `snarkjs wtns calculate ...`                                | Calculate witness                 |
| `snarkjs groth16 prove ...`                                 | Create proof                      |
| `snarkjs zkey export verificationkey ...`                   | Extract verification key          |
| `snarkjs groth16 verify ...`                                | Verify proof                      |

---

## 🧩 Key points I asked again during practice

- `.zkey` is a proof environment based on `.ptau` + `.r1cs`.
- `witness` is the result of internal circuit calculations and is the material for generating proof.
- `withdraw_input.json` contains both public and private values.
- `public.json` contains only values ​​explicitly declared as `signal input public` in the circuit. - `verification_key` is extracted from `.zkey` to only verify the information needed for verification.

---

## 🚀 Summary of the entire flow

````text
[1] Circuit design (.circom)
[2] Circuit compilation → .r1cs, .wasm, .sym
[3] ptau ceremony → randomness contribution
[4] .zkey creation + contribution → proving key completion
[5] Input value definition (withdraw_input.json)
[6] Witness creation (circuit execution result)
[7] Proof creation → proof.json, public.json
[8] Verification key creation → verification_key.json
[9] Verification execution → OK! ```

---

## 🧭 Current steps

- Circuit design ✅
- Circuit compilation ✅
- ptau → zkey generation ✅
- Verifier generation ✅
- Input configuration ✅
- Witness calculation ✅
- Proof generation ✅
- Verification ✅

✅ **Complete ZKP full flow**

---

## 🧭 Future practice direction (planned)

- [ ] Verifier.sol → Hardhat linkage test
- [ ] Merkle Tree-based ZKBridge circuit design
- [ ] AKP: ZK authentication architecture design and circuit design
- [ ] zk-DID circuit design

---

**Practical technology stack**: Circom, snarkjs, VSCode, Groth16 protocol
````
