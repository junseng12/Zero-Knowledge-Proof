# 📚 Circom Practice Summary – SumN, MaxN, SumAndCompare

## ✅ 학습 목표

- Circom 회로 언어의 기본 사용법과 제한 조건 숙달
- 조건문 없는 구조를 통한 연산 설계 훈련
- 복합 회로 합성과 서브 회로 재활용 경험
- Groth16 기반 증명 흐름 전체 자동화

---

## 1️⃣ SumN.circom – 합산 회로

### ▶ 기능

- 입력 배열의 모든 값을 더한 결과를 출력
- 기본 signal, for 루프, 누산 구조 학습

### ▶ 핵심 키워드

`signal input in[n]`, `signal output out`, `<==`, `for`

---

## 2️⃣ MaxN.circom – 최대값 선택 회로

### ▶ 기능

- 조건 분기 없이 최대값을 출력
- 비교기(`GreaterThan(n)`), 중간 signal(`sel_a`, `sel_b`) 활용

### ▶ 배운 점

- 3차항 오류 회피 방법 (중간 곱셈 분리)
- component 배열 미리 선언 필요

---

## 3️⃣ SumAndCompare.circom – 합성 회로 실습

### ▶ 기능

- `SumN`으로 합을 계산하고, `LessThan`으로 threshold 비교
- `isValid` 출력 (sum ≤ threshold → 1)

### ▶ 배운 점

- Circom에서 모듈화 회로를 구성하는 방법
- main 충돌 해결, import 회로 사용법

---

## 🧪 전체 증명 흐름 정리

- ✅ `compile` (`circom`)
- ✅ `setup` (`powersoftau`, `zkey`)
- ✅ `generate_witness.js`
- ✅ `groth16 prove`, `verify`

모든 실습 회로에서 full ZKP flow 성공

---

## 📦 디렉토리 구조 제안

```plaintext
/Circom-Practices/
  ├── SumN/
  ├── MaxN/
  ├── SumAndCompare/
  └── inputs/
```
