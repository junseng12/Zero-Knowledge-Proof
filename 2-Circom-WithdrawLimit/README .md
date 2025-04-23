# 🧠 ZKP 실습 정리: WithdrawLimit (Circom + SnarkJS)

---

## 🎯 실습 목표

- Circom 회로를 설계하고 SnarkJS를 통해 ZK 증명 생성 전체 과정을 실습한다.
- Solidity와의 연동 없이 Circom 내부 로직과 ZKP 흐름을 이해하는 데 집중한다.
- 조건문이 포함된 회로(`withdraw_amount <= 50`)의 동작 원리를 분석한다.

---

## 🔐 Circom 회로 (WithdrawLimit)

```circom
pragma circom 2.0.0;
include "../circomlib/circuits/comparators.circom";

template WithdrawLimit() {
    signal input balance_before;
    signal input withdraw_amount;
    signal input balance_after;
    signal output isValid;

    signal computed;
    signal difference;
    signal isCorrectBalance;
    signal withinLimit;

    computed <== balance_before - withdraw_amount;
    difference <== computed - balance_after;

    component isZero = IsEqual();
    isZero.in[0] <== difference;
    isZero.in[1] <== 0;
    isCorrectBalance <== isZero.out;

    component cmp = LessThan(32);
    cmp.in[0] <== withdraw_amount;
    cmp.in[1] <== 51;
    withinLimit <== cmp.out;

    isValid <== isCorrectBalance * withinLimit;
}

component main = WithdrawLimit();
```

---

## ⚙️ HOW: LessThan 회로는 어떻게 작동하나?

### 🧮 핵심 원리: **비트 단위로 비교하며 carry 전파**

1. 입력 두 값 `a`, `b`를 2진수로 분해
2. 각 자리에서 `a_i`와 `b_i` 비교
3. 높은 자리부터 차례로 carry 전달
4. `a < b`이면 `out = 1`, 아니면 0

### 📦 내부 핵심 구성요소

| 구성 요소       | 설명                                  |
| --------------- | ------------------------------------- |
| `Num2Bits(n)`   | 숫자를 n비트 2진수로 분해             |
| `BitLessThan()` | 두 비트를 비교하는 기본 비교 컴포넌트 |
| AND/OR 게이트   | 이전까지 동일한지를 전파              |

### 🔍 작동 방식

- `a < b`인 첫 비트에서 `lt = 1`
- 이후는 무시하고 결과 고정

### 🔧 시각적 흐름 요약

```
비트 자리:   [7]   [6]   [5]   ...   [0]
            ┌────┬────┬────┐
a_bits →    │  a7│ a6 │ a5 │ ...
b_bits →    │  b7│ b6 │ b5 │ ...
            └────┴────┴────┘
               ↓ 비교
               ↓ eq, lt 계산
        최종 비교 결과 → out = 1 또는 0
```

---

## 🧩 ZKP 전체 흐름 요약

1. **회로 설계**: Circom으로 입력 조건과 출력 정의
2. **컴파일**: `.circom → .r1cs, .wasm`
3. **Powers of Tau**: 공통 설정 생성 (`.ptau`)
4. **ZKey 생성**: 회로 + ptau로 proving/verifying 키 생성
5. **입력 작성**: input.json 구성
6. **witness 생성**: `.wasm`과 input으로 `.wtns` 생성
7. **proof 생성**: `.zkey`, `.wtns`로 `.proof.json`, `.public.json` 생성
8. **검증**: `snarkjs groth16 verify`로 proof 확인

---

## ✅ 핵심 개념 요약

| 항목           | 설명                           |
| -------------- | ------------------------------ |
| `.circom`      | 증명 조건 로직                 |
| `.r1cs`        | 제약 조건 형식                 |
| `.ptau`        | 공통 설정값                    |
| `.zkey`        | proving/verifying 키           |
| `input.json`   | 증명자가 제공한 입력           |
| `witness.wtns` | 조건을 만족하는 계산 결과      |
| `proof.json`   | 증명 데이터                    |
| `public.json`  | 공개 가능한 입력               |
| `isValid`      | 조건 충족 여부 출력 (0 또는 1) |

---

## 📍 기타 팁

- Circom은 신뢰 설정(trusted setup)이 필요한 Groth16 기반이며,
- 회로가 조건을 만족하지 않으면 `isValid=0`이 출력되고,
- `public.json`도 그에 따라 바뀌므로 검증단에서 판단 가능하다.

---
