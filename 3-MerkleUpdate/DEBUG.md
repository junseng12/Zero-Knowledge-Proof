# 🐞 MerkleUpdate 실습 DEBUG LOG

## 🔍 시도 1 – 직접 설정한 Root 입력 (실패)

- `oldLeaf = 15`, `newLeaf = 42`
- pathElements 값만 설정하고 oldRoot/newRoot를 랜덤 수로 지정
- 결과: `isValidUpdate = 0`, public = [ "0" ]
- 원인: 루트 해시 계산 불일치

## 🧠 분석

- Circom 회로에서 실제 leaf 기반으로 Poseidon 해시 연산을 하기 때문에 직접 연산한 결과를 정확히 Root 해시 값으로 넣어줘야 했었음
- 다시 말하자면, 실제 계산 값을 Root에 넣어주지 않는다면, 어떤 것이라도 입력 Root와 실제 계산 Root 해시 값이 다르므로 항상 0 반환
  (oldProof.root != OldRoot, newProof.root != NewRoot)

## ✅ 시도 2 – Poseidon 해시 직접 계산 후 대입

- `oldLeaf = 42`, `newLeaf = 42`
- JS에서 Poseidon 해시 계산을 통해 정확한 루트 도출
- 입력값에 계산된 루트를 넣음
- 결과: public = [ "1" ] → 증명 성공

## 💡 인사이트

- 회로와 외부 계산 로직의 해시 일치가 ZK 증명의 핵심
- Circom은 수학적으로 정직하게 동작함 → 해시 충돌, 경로 순서 불일치 등 작은 실수도 즉시 증명 실패로 연결됨
