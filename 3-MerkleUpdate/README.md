# 🌳 MerkleUpdate.circom – 상태 변경 증명 실습

## 🎯 목표

- 동일한 Merkle 경로와 리프 값을 기준으로 `oldRoot`와 `newRoot`가 일치하는지를 증명
- Circom 회로에서 `MerkleProof`를 두 번 사용하여 상태 변경의 정당성을 검증
- Poseidon 해시를 직접 계산하여 루트 일치 조건을 충족시키는 실험 진행

## 🧩 회로 구조

- `MerkleUpdate(depth)`:
  - 입력: oldLeaf, newLeaf, pathIndices, pathElements, oldRoot, newRoot
  - 내부: 두 MerkleProof를 실행하여 각각 root 계산
  - 출력: `isValidUpdate = oldProof.isIncluded * newProof.isIncluded`

## ✅ 실험 조건

- oldLeaf == newLeaf == 42
- pathIndices = [0,1,0]
- pathElements = [1e39, 2e39, 3e39]
- oldRoot == newRoot = JS에서 Poseidon 해시 직접 계산

## ✅ 결과

- witness 생성 성공
- proof 생성 성공
- verify → **OK**
- public 출력값 → `[ "1" ]`

## 🔗 학습 포인트

- Circom 회로의 해시 흐름을 JS로 재현하여 루트 계산 일치시킴
- ZKBridge/zkRollup 설계에서 Merkle 상태 증명의 핵심 구조 실습
