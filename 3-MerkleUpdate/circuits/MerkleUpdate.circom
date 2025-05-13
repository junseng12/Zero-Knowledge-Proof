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

  //oldLeaf에 대한 oldRoot에 포함 여부 연산
  component oldProof = MerkleProof(depth);
  oldProof.leaf <== oldLeaf;
  for (var i = 0; i < depth; i++){
    oldProof.pathIndices[i] <== pathIndices[i];
    oldProof.pathElements[i] <== pathElements[i];
  }
  oldProof.root <== oldRoot;


  //newleaf 추가에 대한 newRoot 재연산
  component newProof = MerkleProof(depth);
  newProof.leaf <== newLeaf;
  for (var i = 0; i < depth; i++){
    newProof.pathIndices[i] <== pathIndices[i];
    newProof.pathElements[i] <== pathElements[i];
  }
  newProof.root <== newRoot;

  isValidUpdate <== oldProof.isIncluded * newProof.isIncluded;
}

component main = MerkleUpdate(3);