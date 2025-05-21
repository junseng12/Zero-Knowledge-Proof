const { ethers } = require("hardhat");
const fs = require("fs");
const snarkjs = require("snarkjs");

async function main() {
  // 1. Verifier 배포
  const Verifier = await ethers.getContractFactory("Verifier");
  const verifier = await Verifier.deploy();
  await verifier.waitForDeployment();

  // 2. proof + publicSignals 불러오기
  const proof = JSON.parse(fs.readFileSync("proof/proof.json"));
  const publicSignals = JSON.parse(fs.readFileSync("proof/public.json"));

  // 3. Solidity용 call data 자동 생성
  const callData = await snarkjs.groth16.exportSolidityCallData(
    proof,
    publicSignals
  );

  // 4. 문자열 파싱 → BigInt 배열
  const argv = callData
    .replace(/["[\]\s]/g, "") // 괄호, 공백 제거
    .split(",")
    .map((x) => BigInt(x)); // 문자열을 BigInt로 변환

  // 5. Solidity 입력 형식 맞춤
  const a = [argv[0], argv[1]];
  const b = [
    [argv[2], argv[3]],
    [argv[4], argv[5]],
  ];
  const c = [argv[6], argv[7]];
  const input = argv.slice(8); // public inputs

  // 6. verifyProof 실행
  const result = await verifier.verifyProof(a, b, c, input);
  console.log("✅ Verifier result:", result);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
