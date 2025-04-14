# Circom Practice 1: WithdrawProof Circuit

## Goals

- Write a circuit to verify withdrawal status
- Prove balance_before - withdraw_amount == balance_after condition
- Generate ZK proof and prepare Solidity Verifier linkage

## Directory structure

- `circuits/`: Circuit file (.circom)
- `inputs/`: Input value example (withdraw_input.json)
- `build/`: Repository of compilation results and proof-related files
- `verifier/`: Solidity verifier contract
