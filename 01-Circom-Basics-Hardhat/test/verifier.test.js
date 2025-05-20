const { expect } = require("chai");
const fs = require("fs");

describe("Verifier Contract", function () {
  let Verifier;
  let verifier;
  let proof;
  let publicSignals;

  before(async () => {
    Verifier = await ethers.getContractFactory("Groth16Verifier");
    verifier = await Verifier.deploy();

    const rawProof = JSON.parse(fs.readFileSync("./proof/proof.json"));
    const rawPublic = JSON.parse(fs.readFileSync("./proof/public.json"));

    const bigIntify = (arr) => arr.map((x) => BigInt(x));

    proof = {
      a: bigIntify(rawProof.pi_a.slice(0, 2)),
      b: [
        [BigInt(rawProof.pi_b[0][1]), BigInt(rawProof.pi_b[0][0])],
        [BigInt(rawProof.pi_b[1][1]), BigInt(rawProof.pi_b[1][0])],
      ],
      c: bigIntify(rawProof.pi_c.slice(0, 2)),
    };

    publicSignals = bigIntify(rawPublic);
    console.log(proof);
    console.log(publicSignals);
  });

  it("should verify valid proof", async () => {
    const isValid = await verifier.verifyProof(
      proof.a,
      proof.b,
      proof.c,
      publicSignals
    );
    expect(isValid).to.be.true;
  });
});
