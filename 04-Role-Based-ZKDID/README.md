# 🧬 ZKRoleVerifyApp 프로젝트 정리

## 🎯 목적

ZK-SNARK 기반 회로 구조와 Solidity 연동을 통해 **특정 역할(Role ID)의 인증 여부**를 Zero-Knowledge 방식으로 확인하는 시스템을 구현한다.  
이 회로는 Circom 2.0으로 설계되었고, SnarkJS 및 Solidity 연동을 통해 온체인 검증까지 수행하였다.

---

## 📂 파일 구조

```bash
4-Role-Based-ZKDID/
├── contracts/
│   ├── ZKRoleVerifyApp.sol   # zkProof 인증 앱 컨트랙트
│   ├── Verifier.sol          # zkey로부터 생성된 검증기
├── proof/
│   ├── proof.json            # valid proof
│   ├── public.json           # public input
├── test/
│   └── ZKRoleVerifyApp.test.js  # valid/invalid proof 검증 테스트
└── README.md / DEBUG.md
```

---

## 🏗️ 회로 구조 (RoleCheck.circom)

### 입력

- `role`: 사용자의 Role ID
- `expectedRole`: 요구되는 Role ID

### 처리

1. 역할 값 2개 비교 (IsEqual)
2. boolean 강제 조건 적용 (`isAuthorized ∈ {0,1}`)

### 출력

- `isAuthorized`: 1이면 인증 성공, 0이면 실패

---

## 🔧 구성 요소

| 구성 요소     | 경로 / 설명                                     |
| ------------- | ----------------------------------------------- |
| 회로 파일     | `circuits/RoleCheck.circom`                     |
| 비교 구성     | `IsEqual`                                       |
| 증명 생성     | `snarkjs groth16 setup / prove / verify`        |
| Solidity 연동 | `contracts/Verifier.sol`, `ZKRoleVerifyApp.sol` |
| 테스트 파일   | `test/ZKRoleVerifyApp.test.js`                  |

---

## ✅ 성공한 것들

- Circom 회로 컴파일 및 zkey 생성 성공
- proof 생성 및 snarkjs verify 통과
- Verifier.sol 연동 후 Hardhat에서 valid proof 통과 확인
- invalid proof에 대해 정확히 revert 발생 및 감지 확인

---

## ❌ 실패한 부분

- 테스트 초기에 revert가 발생했지만 `try/catch` 방식으로 인해 revert 감지 실패
- `.to.be.revertedWith(...)` 사용 후 테스트 정상 작동

---

## 🧹 정리 판단

> ZK 인증 시스템에서 `revert`는 **보안 실패의 핵심 증거**다.  
> 이 실패를 정확히 감지하기 위한 **테스트 코드의 의도적 예외 감지 구조**가 필수적임을 확인했다.

---

## 🗃️ 관련 파일

- `RoleCheck.circom` – 회로 정의
- `proof/proof.json` – 유효한 증명
- `proof/public.json` – 공개 입력
- `contracts/Verifier.sol` – Solidity 검증 컨트랙트
- `contracts/ZKRoleVerifyApp.sol` – 인증 시스템 컨트랙트
- `test/ZKRoleVerifyApp.test.js` – Hardhat 테스트
