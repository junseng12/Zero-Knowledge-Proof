import { buildPoseidon } from "circomlibjs";
import { Scalar } from "ffjavascript";

const poseidon = await buildPoseidon();

// Step 0: leaf + path
let leaf = Scalar.e(15);
let pathIndices = [0, 1, 0];
let pathElements = [
  Scalar.e("1000000000000000000000000000000000000000"),
  Scalar.e("2000000000000000000000000000000000000000"),
  Scalar.e("3000000000000000000000000000000000000000"),
];

// Step 1: 루트 계산
let hash = leaf;
for (let i = 0; i < 3; i++) {
  const sibling = pathElements[i];
  const [left, right] =
    pathIndices[i] === 0 ? [hash, sibling] : [sibling, hash];
  hash = poseidon([left, right]);
}
const result = poseidon.F.toString(hash); // ← ← 여기 핵심
console.log("✅ 실제 Merkle 루트 =", result);
