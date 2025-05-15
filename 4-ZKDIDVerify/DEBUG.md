# 🔍 ZKDIDVerifier Solidity Integration DEBUG Report

## 📁 프로젝트: 4-ZKDIDVerify

## ✅ 시도한 것들

- Circom 2.0 회로 정상 설계 (ZKDIDVerify.circom)
- Poseidon 해시 기반 userId 비교 → MultiOR → Boolean enforcement → `isAuthorized` 출력
- `snarkjs` Groth16 pipeline 전부 실행 완료:
  - `r1cs`, `zkey`, `proof.json`, `public.json`, `Verifier.sol` 전부 연동
- Solidity Verifier와 Hardhat 배포 스크립트 완료
- Hardhat에서 `verifyProof(a, b, c, input)` 수행

## ✅ 검증된 것

| 항목                          | 결과                               |
| ----------------------------- | ---------------------------------- |
| `snarkjs groth16 verify`      | ✅ OK                              |
| `proof.json` 포맷             | ✅ pi_b.slice(0, 2), BigInt 적용   |
| `Verifier.sol` export         | ✅ zkey에서 직접 생성              |
| `Hardhat clean/compile`       | ✅ 여러 차례 수행                  |
| `input`, `a`, `b`, `c` typeof | ✅ 모두 `bigint`                   |
| Hardhat 주소                  | ❌ 고정 (0x5FbDB... 유지됨)        |
| Docker/WSL 실행               | ❌ 다른 실행 환경에서도 false 반복 |

## ❗ 문제점 요약

- Solidity 상 `verifyProof(...)` 호출 시 false 반환
- Hardhat local network가 바이트코드 동일 시 같은 주소에 컨트랙트 재사용하는 구조
- WSL, Docker Ganache 환경에서도 동일한 false 발생
- 모든 구성 요소가 일치했지만, Hardhat 또는 EVM 내부 pairing mismatch가 발생하는 미확인 상황

## 🧹 정리 판단

> Circom 회로 및 증명 시스템은 정상 작동함.  
> 단, 현재 Hardhat+EVM 구조에서 pairing 검증 실패로 인해 `false` 발생하며,  
> root cause는 `Verifier.sol`과 전달값의 ABI 수준 호환성 불일치일 수 있음.

## 📁 참고 파일

- `ZKDIDApp.test.js` → Hardhat 테스트 실패
- `checkProof.js` → 직접 실행 테스트 실패
