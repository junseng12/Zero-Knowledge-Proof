pragma circom 2.0.0;

include "../../circom/circomlib/circuits/comparators.circom";
include "../../circom/circomlib/circuits/poseidon.circom";

template MerkleProof(depth) {
    signal input leaf;
    signal input pathElements[depth];
    signal input pathIndices[depth];
    signal input root;
    signal output isIncluded;

    signal hash[depth + 1];
    hash[0] <== leaf;

    component hashers[depth];
    
    signal left[depth];
    signal a[depth];
    signal b[depth];


    signal right[depth];
    signal c[depth];
    signal d[depth];


    for(var i = 0; i < depth; i++){

        // pathIndices[i]가 0이면 hash[i]가 왼쪽, pathElements[i]가 오른쪽
        a[i] <== pathIndices[i] * pathElements[i];
        b[i] <== (1 - pathIndices[i]) * hash[i];
        left[i] <== a[i] + b[i];
        
        c[i] <== pathIndices[i] * hash[i];
        d[i] <== (1 - pathIndices[i]) * pathElements[i];        
        right[i] <== c[i] + d[i];

        hashers[i] = Poseidon(2);
        hashers[i].inputs[0] <== left[i];
        hashers[i].inputs[1] <== right[i];
        hash[i+1] <== hashers[i].out;
    }
    
    component isEq = IsEqual();
    isEq.in[0] <== hash[depth];
    isEq.in[1] <== root;
       
    isIncluded <== isEq.out;
}

component main = MerkleProof(3); // 예시로 depth 3 설정
