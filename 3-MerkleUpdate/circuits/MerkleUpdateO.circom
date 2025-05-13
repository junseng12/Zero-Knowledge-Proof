pragma circom 2.0.0;

include "../../circom/circomlib/circuits/comparators.circom";
include "../../circom/circomlib/circuits/poseidon.circom";
include "./MerkleProof.circom";

template MerkleUpdate(depth) {
  signal input oldLeaf;
  signal input newLeaf;
  signal input pathIndices[depth];
  signal input pathElements[depth];
  signal input oldRoot;
  signal input newRoot;
  signal output isValidUpdate;

  signal oldHash[depth + 1];
  oldHash[0] <== oldLeaf;

  component oldHashers[depth];
  component newHashers[depth];

  signal left_old[depth], left_new[depth];
  signal right_old[depth], right_new[depth];
  signal a_old[depth], b_old[depth], c_old[depth], d_old[depth];
  signal a_new[depth], b_new[depth], c_new[depth], d_new[depth];

  //oldLeaf에 대한 oldRoot에 포함 여부 연산
  for (var i = 0; i < depth; i++){
    // pathIndices[i]가 0이면 oldHash[i]가 왼쪽, pathElements[i]가 오른쪽
    a_old[i] <== pathIndices[i] * pathElements[i];
    b_old[i] <== (1 - pathIndices[i]) * oldHash[i];
    left_old[i] <== a_old[i] + b_old[i];

    // pathIndices[i]가 1이면 oldHash[i]가 오른쪽, pathElements[i]가 왼쪽
    c_old[i] <== pathIndices[i] * oldHash[i];
    d_old[i] <== (1 - pathIndices[i]) * pathElements[i];        
    right_old[i] <== c_old[i] + d_old[i];

    oldHashers[i] = Poseidon(2);
    oldHashers[i].input[0] <== left_old[i];
    oldHashers[i].input[1] <== right_old[i];
    oldHash[i+1] <== oldHashers[i].out;
  }

  signal newHash[depth + 1];
  newHash[0] <== newleaf;

  //newleaf 추가에 대한 newRoot 재연산
  for (var i = 0; i < depth; i++){
    a_new[i] <== pathIndices[i] * pathElements[i];
    b_new[i] <== (1 - pathIndices[i]) * newHash[i];
    left_new[i] <== a_new[i] + b_new[i];

    c_new[i] <== pathIndices[i] * newHash[i];
    d_new[i] <== (1 - pathIndices[i]) * pathElements[i];        
    right_new[i] <== c_new[i] + d_new[i];

    newHashers[i] = Poseidon(2);
    newHashers[i].input[0] <== left_new[i];
    newHashers[i].input[1] <== right_new[i];
    newHash[i+1] <== newHashers[i].out;
  }

  component isEqOld = IsEqual();
  isEqOld.in[0] <== oldHash[depth];
  isEqOld.in[1] <== oldRoot;
  
  component isEqNew = IsEqual();
  isEqNew.in[0] <== newHash[depth];
  isEqNew.in[1] <== newRoot;

  isValidUpdate <== isEqOld.out * isEqNew.out;
}

component main = MerkleUpdate(3);