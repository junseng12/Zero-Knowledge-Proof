const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");
const snarkjs = require("snarkjs");

describe("ZKRoleVerifyApp", function () {
  this.timeout(0); // 긴 증명 생성 시간 대비

  let verifierContract, appContract;

  beforeEach(async () => {
    // 1. Verifier 컨트랙트 배포
    const Verifier = await ethers.getContractFactory("Verifier");
    verifierContract = await Verifier.deploy();
    await verifierContract.waitForDeployment();

    // 2. ZKRoleVerifyApp 컨트랙트 배포 (Verifier 주소 주입)
    const App = await ethers.getContractFactory("ZKRoleVerifyApp");
    appContract = await App.deploy(await verifierContract.getAddress());
    await appContract.waitForDeployment();
  });

  it("✅ should authenticate valid ZK proof", async function () {
    // 3. proof, public 입력 불러오기
    const proof = JSON.parse(fs.readFileSync("proof/proof.json"));
    const publicSignals = JSON.parse(fs.readFileSync("proof/public.json"));

    // console.log(proof, publicSignals);
    // ✅ 4. Solidity 입력 형식으로 정석 파싱
    const calldata = await snarkjs.groth16.exportSolidityCallData(
      proof,
      publicSignals
    );
    const argv = calldata
      .replace(/["[\]\s]/g, "")
      .split(",")
      .map((x) => BigInt(x));

    const a = [argv[0], argv[1]];
    const b = [
      [argv[2], argv[3]],
      [argv[4], argv[5]],
    ];
    const c = [argv[6], argv[7]];
    const input = argv.slice(8);

    // 5. 인증 함수 호출
    const tx = await appContract.authenticate(a, b, c, input);
    const receipt = await tx.wait();

    // 6. 이벤트 발생 확인
    // const event = receipt.events?.find((e) => e.event === "Authorized");
    // expect(event).to.not.be.undefined;
  });

  it("❌ should revert when invalid proof is provided", async function () {
    const a = [0n, 0n];
    const b = [
      [0n, 0n],
      [0n, 0n],
    ];
    const c = [0n, 0n];
    const input = [0n];

    const result = await verifierContract.verifyProof(a, b, c, input);
    console.log("✅ Verifier returned:", result); // 반드시 false 나와야 함

    // await appContract.authenticate(a, b, c, input); // <- 아무 처리 없이 이렇게만 실행
    await expect(appContract.authenticate(a, b, c, input)).to.be.revertedWith(
      "Invalid ZK proof"
    ); // <- 이 코드로 인해서 revert는 오류 안 나고 정상 처리됨
  });
});
