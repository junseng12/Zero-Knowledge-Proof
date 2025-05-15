const { ethers } = require("hardhat");

async function main() {
  const Verifier = await ethers.getContractFactory("Verifier");
  const verifier = await Verifier.deploy();
  await verifier.waitForDeployment();
  console.log("🛠️ Deployed verifier at:", await verifier.getAddress());

  const a = [
    BigInt(
      "10023364604351670268762983350765656839770677922757072831508153452107876716410"
    ),
    BigInt(
      "21003372834937760216366058110240675195883376052048934672695298617048782497984"
    ),
  ];

  const b = [
    [
      BigInt(
        "18952994018081767380387360905031287313670361589971326970368985672203687809719"
      ),
      BigInt(
        "20029836713901628941374871449439956137052052571422374493992765937570716743556"
      ),
    ],
    [
      BigInt(
        "651824437950894693411172424010227813140717064337280112728296136486028280863"
      ),
      BigInt(
        "6663375466399040718035621298085452703422459677183551550541482567835380276892"
      ),
    ],
  ];

  const c = [
    BigInt(
      "4222782974015364640147775433759929537559707080525892656131425320060540974326"
    ),
    BigInt(
      "16448024334434157760398773690000152723654599339959427632656936900863050638123"
    ),
  ];

  const input = [BigInt("1")];

  const ok = await verifier.verifyProof(a, b, c, input);
  console.log("✅ on-chain proof ok?", ok);
  console.log("typeof a[0]:", typeof a[0]); // should be "bigint"
  console.log("typeof b[0][0]:", typeof b[0][0]); // should be "bigint"
  console.log("typeof c[0]:", typeof c[0]); // should be "bigint"
  console.log("typeof input[0]:", typeof input[0]); // should be "bigint"
}

main();
