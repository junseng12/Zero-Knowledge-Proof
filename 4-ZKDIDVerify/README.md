# 🆔 ZK-DID 조건부 인증 회로 실습 – ZKDIDVerify.circom

## 🎯 목표

- 사용자 ID 해시가 허용된 DID 해시 목록 중 하나와 일치함을 **제로 지식으로 증명**
- 허용 여부만 공개하고 실제 사용자 정보는 노출하지 않음

## 🧠 회로 구조

### ▶ ZKDIDVerify(N)

- 입력: userIdHash, allowedHashlist[N]
- 출력: isAuthorized (userIdHash ∈ allowedHashlist → 1, 아니면 0)
- 내부 구성:
  - IsEqual() × N → boolean[N]
  - MultiOR(N) → boolean 중 하나라도 1이면 isAuthorized = 1

### ▶ MultiOR(N)

- 입력: in[N]
- 출력: out = (∑ in ≠ 0) → IsEqual(∑ in, 0)의 보수

## ✅ 실험 구성 (N = 5)

- userId: "user777"
- allowedIds: ["user999", "user456", "user123", "user777", "user555"]
- userIdHash ∈ allowedHashlist → 인증 성공 (`isAuthorized == 1`)

## 📁 결과

- proof 생성: ✅
- public 값: `["1"]`
- 검증: ✅ OK
