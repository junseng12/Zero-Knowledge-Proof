const { expect } = require("chai");
const { ethers } = require("hardhat");
const fs = require("fs");

describe("ZKDIDApp", function () {
  this.timeout(0);
  let verifierContract, appContract;

  beforeEach(async () => {
    const Verifier = await ethers.getContractFactory("Verifier");
    verifierContract = await Verifier.deploy();
    await verifierContract.waitForDeployment();

    const ZKDIDApp = await ethers.getContractFactory("ZKDIDApp");
    appContract = await ZKDIDApp.deploy(await verifierContract.getAddress());
    await appContract.waitForDeployment();
  });

  it("✅ should authenticate valid ZK proof", async function () {
    const proofData = JSON.parse(fs.readFileSync("proof/proof.json"));
    const publicSignals = JSON.parse(fs.readFileSync("proof/public.json"));

    const a = [proofData.pi_a[0], proofData.pi_a[1]];
    const b = [
      [proofData.pi_b[0][1], proofData.pi_b[0][0]], // 순서 바꿔야 함
      [proofData.pi_b[1][1], proofData.pi_b[1][0]],
    ];
    const c = [proofData.pi_c[0], proofData.pi_c[1]];
    const input = [publicSignals[0].toString()]; // 숫자 문자열 형태로 변환

    console.log("🧪 publicSignals:", publicSignals);
    console.log("✅ Proof inputs:", a, b, c, input);

    await expect(appContract.authenticate(a, b, c, input)).to.emit(
      appContract,
      "Authorized"
    );
  });

  it("❌ should reject invalid ZK proof", async function () {
    const failData = JSON.parse(fs.readFileSync("proof/fail.json"));
    const a = [failData.pi_a[0], failData.pi_a[1]];
    const b = [
      [failData.pi_b[0][1], failData.pi_b[0][0]], // 순서 바꿔야 함
      [failData.pi_b[1][1], failData.pi_b[1][0]],
    ];
    const c = [failData.pi_c[0], failData.pi_c[1]];
    const input = [publicSignals[0].toString()]; // 숫자 문자열 형태로 변환

    await expect(appContract.authenticate(a, b, c, input)).to.be.revertedWith(
      "Invalid ZK proof"
    );
  });
});
