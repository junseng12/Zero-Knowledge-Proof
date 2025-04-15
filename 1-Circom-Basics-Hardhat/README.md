# 🛠 ZK-SNARK Circom 실습 (with Hardhat 연동)

이 레포는 Circom 회로 설계부터 Solidity 스마트 컨트랙트 연동까지의 전체 ZK-SNARK 흐름을 다루며, 특히 Groth16 기반 증명 생성 및 검증을 중심으로 진행되었습니다.

---

## 🔍 실습 목표

- Circom으로 **ZK 회로 설계**
- SnarkJS로 **witness, proof 생성 및 검증**
- Solidity `verifier.sol` 연동 후 **Hardhat 테스트 성공**
- ZK 흐름에 대한 **실전 기반 이해 확보**

---

## 🧱 폴더 구조

```
Zero-Knowledge-Proof/
├── 1-Circom-Basics/                  # Circom 회로 설계, proof 생성
├── 1-Circom-Basics-Hardhat/          # Hardhat 연동 테스트 환경
├── proof/                            # proof.json / public.json
├── build/                            # wasm, r1cs, witness, zkey
├── contracts/Verifier.sol            # Solidity 검증기
├── test/verifier.test.js             # Hardhat 테스트 코드
└── README.md
```

---

## 🔄 전체 흐름 요약 (개념 + 실습)

```plaintext
1. 회로 설계 (WithdrawProof.circom)
2. 회로 컴파일 → .r1cs, .wasm, .sym
3. Powers of Tau Ceremony → .ptau
4. Trusted Setup (Groth16) → .zkey
5. 입력값 준비 → withdraw_input.json
6. witness.wtns 생성
7. zk-SNARK proof 생성 (.proof.json, .public.json)
8. Solidity Verifier.sol 생성
9. Hardhat 테스트 연동
```

---

## 🧠 연동 시 중요한 개념

- `publicSignals`은 Circom 회로의 출력 포함 → `isValid` 포함 필요
- `pi_b` 좌표는 Solidity에서 `(y, x)` 순서로 입력
- Solidity `verifyProof()`는 정확히 `4개 입력`을 기대함 (isValid 포함)

---

## ✅ 최종 결과

- `snarkjs groth16 verify ...` → `OK!` 출력
- `npx hardhat test` → `✔ should verify valid proof`

---

## 📦 기술 스택

- Circom v0.5.46
- snarkjs v0.7.5
- Solidity ^0.8.28
- Hardhat ^2.x

---

## 📁 기타 문서

- `DEBUG.md`: 연동 중 발생한 오류 및 해결 과정
- `ZKP_실습_정리.md`: 이론/비유 중심 개념 정리

---

## ✍️ Contributor

이준승 — Cybersecurity @ Ajou University  
실습 목표: 사람을 위한 안전한 인프라 설계