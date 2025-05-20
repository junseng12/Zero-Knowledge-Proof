# 🧬 Zero-Knowledge-Proof Circom Practice Suite

이 저장소는 **Circom 및 ZKP 시스템**에 대한 체계적이고 실습 중심적인 학습 기록을 담고 있습니다.
산술 연산부터 Merkle 트리, DID 인증 등 **프라이버시 보존 회로 설계**를 깊이 있게 이해하도록 구성되었습니다.

---

## 🔐 What is Zero-Knowledge Proof (ZKP)?

<img src="..\Images\Zero-Knowledge-Proof-Concept.PNG" width="600px" height="400px">

\*\*Zero-Knowledge Proof (ZKP)\*\*는 한쪽(증명자)이 상대(검증자)에게 자신이 특정 정보를 알고 있음을 그 정보를 직접적으로 노출하지 않고 증명할 수 있게 해주는 암호학적 기술입니다.

### 🚩 ZKP Use-Cases

- **ZK-DID**: 사용자 신원을 드러내지 않고 자격 증명
- **ZK-Rollups**: Layer-2 블록체인에서 세부 거래 정보 숨기고 검증
- **ZK-Bridge**: 민감한 자산 소유권을 보호하며 크로스 체인 통신

### ✨ Intuition Example:

> "비밀 문을 통과할 수 있는 비밀번호를 직접 말하지 않고도,
> 문을 열고 다시 돌아와서 상대에게 그 비밀번호를 알고 있음을 확신시킬 수 있습니다."

### 🧱 Types of ZKPs

| Type             | 특징                                               | 대표적 사용 예시                |
| ---------------- | -------------------------------------------------- | ------------------------------- |
| **zk-SNARKs**    | 효율적인 짧은 증명, trusted setup 필요             | zkSync, Aztec, Zcash 등         |
| **zk-STARKs**    | 투명한 설정 과정, 포스트 양자 보안, 증명 길이 증가 | StarkWare 기반 시스템           |
| **Bulletproofs** | 짧은 증명, trusted setup 불필요                    | 기밀 트랜잭션 (Confidential Tx) |

---

## 🧠 Why This Repository?

- 실제 시스템(ZK-DID, ZKBridge)에서의 ZKP 작동 원리 이해
- 실무에 적용 가능한 재사용 가능한 Circom 회로 라이브러리 구축
- 블록체인 프라이버시 연구 관심사를 실질적인 회로 설계와 연결

---

## 🧭 Directory Structure

```bash
Zero-Knowledge-Proof/
├── 01-Circom-Basics/
│   ├── Sum.circom, Max.circom, ...
├── 01-Circom-Basics-Hardhat/
│   └── Verifier.sol (Hardhat 연동 실습)
├── 01-Circom-Practices/
│   └── 중급 회로 (SumAndCompare, ArrayEqual 등)
├── 02-Circom-Withdraw-Limit/
│   ├── WithdrawProof.circom, WithdrawLimit.circom, ...
├── 03-MerkleProof/
│   └── Merkle Inclusion 회로
├── 03-MerkleUpdate/
│   └── Merkle Path Update 회로
├── 04-ZKDIDVerify/
│   └── DID 인증 회로
├── circom/ (빌드용 Circom 소스)
├── KR/
│   └── README-KR.md
├── README.md
└── README-for-Developer.md
```

---

## 📂 Practice Flow and Structure

| 단계         | 폴더                       | 내용 요약                                        |
| ------------ | -------------------------- | ------------------------------------------------ |
| 🔹 Step 1    | `01-Circom-*`              | 기초 산술/비교 회로 설계 (signal, comparator 등) |
| 🔸 Step 2    | `02-Circom-Withdraw-Limit` | 조건 기반 회로 (LessThan, 조건 제어 로직)        |
| 🔷 Step 3    | `03-Merkle*`               | Merkle 트리 기반 구조 (Merkle 증명, 업데이트)    |
| 🔐 Step 4    | `04-ZKDIDVerify`           | DID 인증 회로 설계 (Merkle + Hash 로직)          |
| ⚙️ Auxiliary | `circom/`                  | Circom 소스 (빌드 및 관리용)                     |

---

## 🔄 Standardized Folder Contents

각 폴더는 다음 파일들로 구성됩니다:

- `circuit.circom`: Circom 회로 코드
- `input.json`: 예시 입력
- `proof.json`: 생성된 증명
- `verifier.sol`: Solidity 검증 코드 (필요 시)

---

## 🔬 Key Theoretical Highlights

- **LessThan + IsEqual**: 조건부 제한 (WithdrawLimit에서 사용)
- **MerkleProof**: Merkle Root 내 해시된 데이터 포함 여부 검증
- **ArrayEqual + SumAndCompare**: 일괄 비교 논리 구현

---

## 📚 Future Expansion (Research-Oriented Roadmap)

### 1️⃣ **ZK-DID v2: Anonymous Access with Revocation**

- **Anonymous Login**, **Selective Disclosure**, **Credential Revocation**
- 장기적인 프라이버시 보호 및 평판 관리 시스템

### 2️⃣ **ZKBridge: Cross-Chain State Commitment**

- **Off-chain Proof Generation**, **On-chain Verification**
- 크로스 체인 데이터 동기화의 신뢰·지연 문제 해결

### 3️⃣ **Recursive zkRollup Circuit Simulator**

- **Proof Aggregation**, **Recursive Proof Chaining**
- 재귀적 증명을 활용한 Rollup의 확장성 개선

### 4️⃣ **ZK-SmartContract Auditor**

- **Bytecode Analysis**, **Vulnerability Detection without Revealing Code**
- 스마트 컨트랙트의 프라이버시 보장형 온체인 보안 감사 시스템

### 5️⃣ **Privacy-Aware Reputation System**

- **Threshold ZK-Proofs**, **Merkle Tree Dynamic Updates**
- 개인정보 보호를 유지하며 사용자 평판 관리 시스템 구축

---

📎 [영어 문서 보기](../README.md)
📎 [개발자용 실습 가이드](./README-for-Developer.md)

---
