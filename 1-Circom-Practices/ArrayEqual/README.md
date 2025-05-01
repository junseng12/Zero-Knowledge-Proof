# 🧮 ArrayEqual.circom – Circom Practice

## 🎯 목표

- 두 개의 배열이 동일한지를 Circom 회로 상에서 증명 가능하도록 구성
- 조건 분기 없이, 각 요소 비교 후 누산 곱 연산으로 전체 비교

## 🧩 핵심 개념

- `IsEqual()` 비교기 활용
- 중간 signal 체이닝 방식으로 `<==` 제약 회피
- `a[n]`, `b[n]`의 각 요소 비교 후 AND 누적
- 출력 `isEqual == 1`이면 두 배열이 완전히 동일함을 증명

## 🧮 입력 예시

```json
{
  "a": [1, 2, 3, 4, 5],
  "b": [1, 2, 3, 4, 5]
}
```

---

# 🐞 ArrayEqual 디버깅 기록

```markdown
# 🐛 ArrayEqual.circom Debug Log

## ❗ 주요 이슈

1. `<==` 중복 오류 가능성  
   → `isEqual <== ...` 반복 대신 `result[n]` 활용하여 해결

2. 입력 JSON 구조 설계  
   → 배열 2개를 분리하여 `"a"`, `"b"`로 선언해야 함

## 💡 배운 점

- Circom에서 signal은 반드시 단일 할당만 가능하므로 누산 계산에 중간 signal이 필요
- 구조적으로 비교기를 활용한 회로 설계는 조건 회로의 기초
```
