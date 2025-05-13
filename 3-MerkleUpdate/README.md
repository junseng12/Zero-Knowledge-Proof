# 🌳 MerkleUpdate.circom – 상태 변경 증명 실습

## 🎯 목표

- 동일한 Merkle 경로와 다른 리프 값(oldLeaf, newLeaf)을 기준으로 각각 `oldRoot`, `newRoot`와 연산상 일치하는지를 증명
- Circom 회로에서 `MerkleProof`를 두 번 사용하여 상태 변경의 정당성을 검증
- Poseidon 해시를 직접 계산하여 루트 일치 조건을 충족시키는 실험 진행

## 🧩 회로 구조

- `MerkleUpdate(depth)`:
  - 입력: oldLeaf, newLeaf, pathIndices, pathElements, oldRoot, newRoot
  - 내부: 두 MerkleProof를 실행하여 각각 root 해시 계산
  - 출력: `isValidUpdate = oldProof.isIncluded * newProof.isIncluded`

## ✅ 실험 조건

- oldLeaf = 15, newLeaf == 42
- pathIndices = [0,1,0]
- pathElements = [1e39, 2e39, 3e39]
- oldRoot , newRoot => CalculateHash.js에서 Poseidon 해시 직접 계산
  oldRoot = 18129223710779012867742188958021926789121489949453298481536199497903687941285,
  newRoot = 18508721506089471087325412583889155894209218720245937662234099984764426476687
- 실제 input값에 반영하여 실험 진행

## ✅ 결과

- witness 생성 성공
- proof 생성 성공
- verify → **OK**
- public 출력값 → `[ "1" ]`

## 🔗 학습 포인트

- Circom 회로의 해시 흐름을 JS로 재현하여 각 Leaf에 대해 실제 해시 계산 일치시킴
- 실제 변환된 값을 입력할 경우,
  각각 oldProof.isIncluded == 1, newProof.isIncluded == 1 이 되며,
  isValidUpdate == 1 이 됨 (public에서 결과 확인 가능)
- ZKBridge/zkRollup 설계에서 Merkle 상태 증명의 핵심 구조 실습
