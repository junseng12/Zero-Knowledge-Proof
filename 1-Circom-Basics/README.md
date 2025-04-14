# Circom 실습 1: WithdrawProof 회로

## 목표

- 출금 상태 검증 회로 작성
- balance_before - withdraw_amount == balance_after 조건을 증명
- ZK 증명 생성 및 Solidity Verifier 연동 준비

## 디렉터리 구조

- `circuits/`: 회로 파일 (.circom)
- `inputs/`: 입력값 예제 (withdraw_input.json)
- `build/`: 컴파일 결과 및 증명 관련 파일 저장소
- `verifier/`: Solidity 검증자 컨트랙트
