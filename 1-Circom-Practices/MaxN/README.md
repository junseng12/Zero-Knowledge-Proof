# 🔧 MaxN.circom – Circom Practice

## 🎯 목표

입력된 n개의 숫자 중 조건 분기 없이 최대값을 선택하는 회로 구현

## 🧩 핵심 회로 개념

- `GreaterThan(n)` 비교기 사용
- 반복문에서 `component cmp[n]` 배열 선언 → 회로의 정적 구조 보장
- 3차항 제약 회피를 위해 중간 곱셈 결과 분리: `sel_a`, `sel_b`
- 최종 출력은 누적된 temp[n-1] 사용

## 🧮 입력 예시

```json
{
  "in": [11, 23, 7, 66, 2, 31, 5, 99, 44, 12]
}
```

---

## 📄 `Debug.md` – MaxN 디버깅 기록

```markdown
# 🐞 MaxN.circom Debug Log

## 📌 주요 디버깅 이슈

1. `IsGreaterThan()` → 정의되지 않은 비교기 → `GreaterThan(n)`으로 수정
2. `component` 반복문 내 선언 불가 → `cmp[n]` 배열 구조로 변경
3. 3차항 오류 발생 → `(a * b) + (c * d)` 구조를 중간 signal로 나눠 해결

## 💡 배운 점

- Circom은 정적 회로 생성 기반이기 때문에 모든 컴포넌트는 루프 바깥에 선언
- 제약식은 반드시 2차항 이내로 제한되어야 함 → 중간 곱셈 분해 필수
```
