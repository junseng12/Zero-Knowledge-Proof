# 🔍 ZKDIDVerifier Solidity Integration DEBUG Report

## 📁 프로젝트: 4-ZKDIDVerify

---

## 🎯 목표

- Circom 2.0 회로로 생성한 Groth16 zk-SNARK 증명을 Solidity 환경에서 검증
- `Verifier.sol`과 `ZKDIDApp.sol`을 Hardhat 테스트로 통합
- 올바른 proof는 `Authorized` 이벤트 발생, 잘못된 proof는 `Invalid ZK proof` revert 유도

---

## ✅ 구현 및 확인된 요소

| 항목                          | 상태    | 설명                                              |
| ----------------------------- | ------- | ------------------------------------------------- |
| Circom 회로 컴파일            | ✅ 성공 | `ZKDIDVerify.circom` with Poseidon hash & OR tree |
| Groth16 trusted setup         | ✅ 성공 | phase1 & phase2 → final zkey 생성                 |
| Verifier.sol 생성             | ✅ 성공 | `snarkjs zkey export solidityverifier` 사용       |
| proof.json / public.json 생성 | ✅ 성공 | `snarkjs groth16 fullprove`로 생성                |
| Solidity에서 verifyProof()    | ✅ 성공 | 하드코딩 제거 후 동적 인자 처리                   |
| 테스트 valid proof 통과       | ✅ 성공 | Authorized 이벤트 발생 확인                       |
| 테스트 invalid proof 실패     | ✅ 성공 | revert with "Invalid ZK proof" 확인               |

---

## ❗ 핵심 문제 요약

### 🚨 `pi_b`의 순서 오류가 가장 치명적이었음

Circom → `snarkjs`의 proof 구조는 다음과 같이 생성됨:

```json
"pi_b": [
  [b00, b01],
  [b10, b11]
]
```

그러나 Solidity에서는 pairing 함수의 요구로 인해 좌표 순서가 반대로 들어가야 함:

```Solidity
b = [
  [b01, b00],
  [b11, b10]
];
```

이 구조적 mismatch로 인해 다음과 같은 문제가 발생함:
| 증상 | 원인 |
| ----------------------------- | ------------------------------ |
| Remix에서 항상 `false` 반환 | b 순서 mismatch |
| Hardhat 테스트에서 항상 실패 | b 좌표가 Circom 순서 그대로 사용됨 |
| invalid proof도 `true`가 나오는 현상 | Verifier 내부 계산이 무의미해짐 (좌표 불일치) |

---

### 🔧 해결 코드 스니펫 (ZKDIDApp.test.js)

```js
const a = [proofData.pi_a[0], proofData.pi_a[1]];
const b = [
  [proofData.pi_b[0][1], proofData.pi_b[0][0]], // ✅ 순서 반드시 바꿔야 함!
  [proofData.pi_b[1][1], proofData.pi_b[1][0]],
];
const c = [proofData.pi_c[0], proofData.pi_c[1]];
const input = [publicSignals[0].toString()];
```

---

## 🧪 테스트 로그 (요약)

### ✅ Valid proof 테스트

```bash
✅ should authenticate valid ZK proof
🧪 publicSignals: [ '1' ]
📌 Verifier Address: 0x5FbDB...
✔ Authorized 이벤트 발생
```

### ✅ Invalid proof 테스트

```bash
❌ should reject invalid ZK proof
✔ Transaction reverted with 'Invalid ZK proof'
```

---

## 📌 교훈 요약

| 항목                     | 실수 요인                          | 해결 방법                                        |
| ------------------------ | ---------------------------------- | ------------------------------------------------ |
| Verifier.sol 재생성 누락 | zkey와 불일치 → false              | `snarkjs zkey export solidityverifier` 다시 수행 |
| 입력 하드코딩            | 테스트 무효화                      | 외부 입력으로 수정                               |
| **b 순서 미변환 (중요)** | `false` or undefined → 디버깅 실패 | b 좌표 순서 반드시 변경                          |
| public input 형변환 문제 | `uint8[1]` vs `uint256[1]` 오류    | `uint256(...)` 명시적으로 적용                   |

---

## ✅ 결론

이 실습의 본질적인 디버깅 핵심은 바로 pi_b 순서 오류였습니다.
초기에는 zkey, 회로, input이 모두 정상임에도 Solidity에서 계속 false를 반환한 이유는
pairing 함수가 좌표 순서를 기대하는 방식과 snarkjs 출력 포맷이 구조적으로 달랐기 때문입니다.

이 오류를 해결함으로써 Solidity에서 ZKP를 안정적으로 검증하는 전체 흐름을 마무리할 수 있었습니다.

---
