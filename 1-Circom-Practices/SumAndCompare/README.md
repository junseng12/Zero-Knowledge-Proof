# 🔁 SumAndCompare.circom – Circom Practice

## 🎯 목표

- 입력된 숫자 배열의 합이 일정 threshold 이하인지를 회로 내에서 판단하는 합성 회로 설계
- `SumN` 회로와 `LessThan` 비교기를 연결하여 서브모듈 구조 설계 실습

## 🧩 핵심 개념

- `component summer = SumN(n)`를 통해 회로 내부 합산
- `component checker = LessThan(32)`로 임계값과 비교
- 조건 분기 없는 회로식으로 `isValid = 1 or 0` 반환

## 🧮 입력 예시

```json
{
  "in": [7, 6, 10, 9, 8]
}
```

---

# 🐞 SumAndCompare 디버깅 기록

```markdown
# 🐛 SumAndCompare.circom Debug Log

## 🔎 주요 문제 & 해결

1. ❌ multiple main component 에러  
   → `SumN.circom` 내부 `component main` 삭제

2. ❌ signal/var 구분 오류 (for문 `i = ...`)  
   → `for (var i = 0; ...)`로 수정

3. ❌ 파일 경로 오류 (ENOENT)  
   → `../inputs/...` → `./inputs/...`로 상대 경로 조정

## 💡 배운 점

- 모듈화된 회로를 재활용하려면 main 충돌 방지 필요
- witness 입력 파일은 정확한 경로 위치 필수
- Groth16 setup 흐름 자동화 구조 확립
```
