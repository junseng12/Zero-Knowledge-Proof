# 🔍 DEBUG.md — Hardhat 연동 중 발생한 주요 오류 정리

이 문서는 Circom 회로 기반 ZK-SNARK 증명을 Hardhat을 통해 Solidity와 연동하는 과정에서 발생한 **주요 오류들과 해결 과정**을 정리한 것입니다.

---

## 🧨 주요 오류 리스트 및 해결 방식

### 1. `verifier.deployed is not a function`

**오류 메시지:**

```
TypeError: verifier.deployed is not a function
```

**원인:**

- Circom에서 생성된 `verifier.sol`은 constructor 없는 유틸리티 컨트랙트 형태로, `deployed()` 같은 Hardhat 트래킹 기능과 호환되지 않음.

**해결 방법:**

```js
// 이 코드는 제거해야 함
// await verifier.deployed();
```

---

### 2. `array is wrong length`

**오류 메시지:**

```
Error: array is wrong length
```

**원인:**

- Solidity `verifyProof()` 함수가 요구하는 정확한 배열 구조와 전달된 JS 배열이 일치하지 않을 경우 발생.
- 특히 `pi_b`의 좌우 반전 여부, `publicSignals`의 개수, 순서 등이 중요.

**해결 방법:**

```js
// 좌우 반전 필요 (snarkjs는 좌표 순서가 다름)
b: [
  [BigInt(pi_b[0][1]), BigInt(pi_b[0][0])],
  [BigInt(pi_b[1][1]), BigInt(pi_b[1][0])],
];
```

---

### 3. `expected true but got false` (AssertionError)

**오류 메시지:**

```
AssertionError: expected false to be true
```

**원인:**

- 증명이 유효하지 않을 경우 발생
- 주로 입력값 오류, witness 생성 실패, 혹은 public input과 verifier의 예상 input mismatch

**해결 방법:**

- Circom 회로를 다시 컴파일하고 `.zkey`, `.ptau`, `verifier.sol` 전부 재생성 후 증명 재시도

---

### 4. public.json 구조 mismatch

**오류 메시지:** `invalid array value`, 혹은 array length mismatch

**원인:**

- Solidity `verifyProof()`가 정확히 4개의 `uint` public input을 받는데, `public.json`에서 `[isValid, input1, input2, input3]` 모두 포함돼야 함

**해결 방법:**

- 테스트 코드에서 `publicSignals = rawPublic.slice(1)`처럼 `isValid` 제거 시도는 실패
- **결론:** `public.json`은 Circom 회로의 모든 `signal output`과 `input` 포함 필요 → `4개`

---

## ✅ 최종적으로 작동한 구조 요약

```js
proof = {
  a: bigIntify(pi_a.slice(0, 2)),
  b: [
    [BigInt(pi_b[0][1]), BigInt(pi_b[0][0])],
    [BigInt(pi_b[1][1]), BigInt(pi_b[1][0])],
  ],
  c: bigIntify(pi_c.slice(0, 2)),
};

publicSignals = bigIntify(rawPublic); // 전체 4개 유지
```

---

## 🧠 실전 팁

- **Hardhat 테스트 실패시**, 다음 순서대로 점검:
  1. Verifier.sol 내 `verifyProof()` 시그니처와 입력값 일치 여부
  2. proof/public.json 의 값 개수, 순서, 타입 확인
  3. .zkey / verifier.sol / input.json 재생성 여부 확인
