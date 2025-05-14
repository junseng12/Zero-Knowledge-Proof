# 🐞 ZK-DID 회로 실습 DEBUG LOG

## 🧪 시도

- input: userId = "user777"
- 실제 input 값 : 이들을 임의의 해시값으로 표현하여 입력함.
- 허용된 리스트: 포함됨 → 인증 성공 예상

## ⚙️ 흐름

1. Circom 회로 작성
   - `IsEqual()` × 5, `MultiOR()` 조합 설계
2. SHA256 기반 해시 사용 (Poseidon 대체)
3. JS로 userIdHash, allowedHashlist 계산
4. witness → proof → verify 순으로 실행
5. public: `["1"]` → 검증 성공

## 🔍 주요 포인트

- Circom에서는 배열 연결 시 직접 반복문으로 연결 필요
- signal 중복 할당 주의
- `IsEqual(x, 0)` → `IsZero()` 역할 대체 가능
