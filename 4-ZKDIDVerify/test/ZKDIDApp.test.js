const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("ZKDIDApp", function () {
  this.timeout(0); // 디버깅 중일 때만 추천
  let verifierContract, appContract;

  beforeEach(async () => {
    const Verifier = await ethers.getContractFactory("Verifier");
    verifierContract = await Verifier.deploy();
    //Verifier.sol은 constructor()도 없고, 상태 변경도 없음
    // deploy()만 해도 address가 즉시 할당됨
    // 따라서 실제 네트워크 배포에서도 deployed() 없이도 정상 작동함
    // 즉, Verifier는 “배포 완료를 기다릴 필요가 없는 컨트랙트”라서 생략 가능함
    // await verifierContract.deployed();
    // 안전하게 배포 트랜잭션이 완료될 때까지 기다려야 함!
    await verifierContract.waitForDeployment(); // v6에서 deployed() 대신 이거 써야 함

    const ZKDIDApp = await ethers.getContractFactory("ZKDIDApp");
    appContract = await ZKDIDApp.deploy(await verifierContract.getAddress());
    await appContract.waitForDeployment();
  });

  it("✅ should authenticate valid ZK proof", async function () {
    const proofData = JSON.parse(fs.readFileSync("proof/proof.json"));
    const publicSignals = JSON.parse(fs.readFileSync("proof/public.json"));

    // 증명 포맷 맞춰서 구조화
    const a = [proofData.pi_a[0], proofData.pi_a[1]];
    const b = [
      [proofData.pi_b[0][0], proofData.pi_b[0][1]],
      [proofData.pi_b[1][0], proofData.pi_b[1][1]],
    ];
    const c = [proofData.pi_c[0], proofData.pi_c[1]];
    const input = [publicSignals[0].toString()];
    // const input = publicSignals.map((x) => x.toString());
    abc = await verifierContract.verifyProof(a, b, c, input);
    console.log("🧪 publicSignals:", publicSignals);
    console.log("🧪 input to contract:", input);
    console.log("✅ Proof inputs:", a, b, c, input);
    console.log("📌 Verifier Address:", await verifierContract.getAddress());
    // 실행
    const tx = await appContract.authenticate(a, b, c, input);
    // await tx.wait();
    const receipt = await tx.wait();
    const event = receipt.events?.find((e) => e.event === "Authorized");
    expect(event).to.not.be.undefined;

    expect(tx).to.emit(appContract, "Authorized");
  });

  it("❌ should reject invalid ZK proof", async function () {
    // ❌ 유효하지 않은 증명 입력 생성 (0으로 채운 값들)
    const a = ["0", "0"];
    const b = [
      ["0", "0"],
      ["0", "0"],
    ];
    const c = ["0", "0"];
    const input = ["0"];

    // 👇 기대: 이 트랜잭션은 실패해야 한다
    await expect(appContract.authenticate(a, b, c, input)).to.be.revertedWith(
      "Invalid ZK proof"
    );
  });
});
