# 🧬 ZKDIDVerify 프로젝트 정리

## 🎯 목적

ZKDID 기반 회로 설계를 통해 **허용된 사용자 ID 목록**과의 일치 여부를 Zero-Knowledge 방식으로 인증하는 시스템을 구현한다.  
이 회로는 Circom 2.0으로 작성되었으며, Solidity와 SnarkJS를 통해 온체인 검증까지 연동을 목표로 하였다.

---

## 📂 파일 구조

```bash
4-ZKDIDVerify/
├── contracts/
│ ├── ZKDIDApp.sol # zkProof 인증 앱
│ ├── Verifier.sol # zkey로부터 생성된 검증기
├── proof/
│ ├── fail.json # invalid proof
│ ├── proof.json # valid proof
│ ├── public.json # public input
├── test/
│ └── ZKDIDApp.test.js # valid/invalid proof 검증 테스트
└── README.md / DEBUG.md
```

---

## 🏗️ 회로 구조 (ZKDIDVerify.circom)

### 입력

- `userIdRaw`: 사용자가 입력한 원본 ID (정수)
- `allowedRawList[N]`: 허용된 ID 리스트

### 처리

1. Poseidon 해시로 사용자 ID와 리스트 값 해싱
2. 각 해시값 간 IsEqual 비교
3. MultiOR 회로를 이용해 하나라도 일치하면 통과
4. Boolean 제약: `isAuthorized ∈ {0, 1}` 강제

### 출력

- `isAuthorized`: 1이면 인증 성공, 0이면 실패

---

## 🔧 구성 요소

| 구성 요소     | 경로 / 설명                                      |
| ------------- | ------------------------------------------------ |
| 회로 파일     | `circuits/ZKDIDVerify.circom`                    |
| 해시 구성     | `Poseidon` from circomlib                        |
| 비교 구성     | `IsEqual`, `MultiOR`                             |
| 증명 생성     | `snarkjs groth16 setup / prove / verify`         |
| Solidity 연동 | `contracts/Verifier.sol`, `ZKDIDApp.sol`         |
| 테스트 파일   | `scripts/checkProof.js`, `test/ZKDIDApp.test.js` |

---

## ✅ 성공한 것들

- Circom 회로 작성 및 `r1cs` / `wasm` / `zkey` 생성
- proof 생성 및 `snarkjs verify` 성공
- Verifier.sol 연동 및 Hardhat compile 완료

---

## ❌ 실패한 부분

- `verifier.verifyProof(...)` 호출 시 `false` 반환
- Hardhat local network에서 같은 주소로 계속 배포되어 상태 초기화 실패 의심
- Docker, WSL 등으로 테스트해도 pairing mismatch 계속 발생
- JS 전달값은 모두 BigInt, 포맷 정확했음에도 실패

---

## 🧹 정리 판단

> 회로 설계 및 증명은 모두 정상  
> 문제는 Solidity Verifier 상 pairing check 실패이며, 이는 **ABI-level 타입 mismatch**, 또는 **Hardhat의 캐시된 EVM 상태 문제**일 가능성이 높음

---

## 🗃️ 관련 파일

- `ZKDIDVerify.circom` – 회로 정의
- `MultiOR.circom` – 다중 비교용 회로
- `input.json` – 사용자 입력
- `proof/proof.json` – 증명
- `proof/fail.json` – 실패용 증명
- `proof/public.json` – 공개 입력
- `contracts/Verifier.sol` – Solidity 검증 컨트랙트
- `test/ZKDIDApp.test.js` – Hardhat 테스트
- `scripts/checkProof.js` – 개별 proof 검증 스크립트
