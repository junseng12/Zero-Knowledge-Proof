pragma circom 2.0.0;

include "../../circom/circomlib/circuits/comparators.circom";
include "../../circom/circomlib/circuits/poseidon.circom";
include "./MultiOR.circom";

template ZKDIDVerify(N) {
    signal input userIdHash;
    signal input allowedHashlist[N];
    signal output isAuthorized;

    signal boolean[N];

    component isEq[N];
    for(var i = 0; i < N; i++){
        isEq[i] = IsEqual();
        isEq[i].in[0] <== allowedHashlist[i];
        isEq[i].in[1] <== userIdHash;

        boolean[i] <== isEq[i].out;
    }

    component or = MultiOR(N);
    for (var i = 0; i < N; i++) {
        or.in[i] <== boolean[i];
    }

    isAuthorized <== or.out;
}

component main = ZKDIDVerify(5); // 예시로 depth 3 설정
