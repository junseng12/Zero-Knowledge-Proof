# ➕ SumN.circom – Circom Practice

## 🎯 목표

배열로 주어진 숫자 n개의 총합을 계산하는 간단한 회로를 설계하고 증명 흐름을 따라 실습

## 🧩 핵심 회로 개념

- `for` 반복문을 통한 누적 합 구조
- 배열 `in[n]` 입력, 출력 `out`
- Circom에서는 `out` 값을 루프 내에서 누적하는 방식으로 선언
- 기본적인 signal 연결과 순차적 계산 로직 이해

## 🧮 입력 예시

```json
{
  "in": [3, 5, 7, 2, 8, 10]
}
```

---

## 📄 SumN 디버깅 기록

```markdown
# 🐞 SumN.circom Debug Log

## 📌 주요 디버깅 이슈

- `sum <==`을 루프 내에서 두 번 선언하여 signal 재할당 에러 발생 → `sum` 대신 누적 배열 `temp[]`로 대체 가능

## 💡 배운 점

- Circom은 한 signal에는 단 한 번만 `<==`을 사용할 수 있음
- 기본적인 루프 누적 방식에서의 회로 구현 감각을 익힘
```
