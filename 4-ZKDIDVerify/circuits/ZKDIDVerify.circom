pragma circom 2.0.0;

include "../../circom/circomlib/circuits/poseidon.circom";
include "../../circom/circomlib/circuits/comparators.circom";
include "./MultiOR.circom";

template ZKDIDVerify(N) {
    // 입력: 사용자 원본 ID와 허용된 ID들 (모두 Raw 정수)
    signal input userIdRaw;
    signal input allowedRawList[N];
    signal output isAuthorized;

    // 사용자 해시 계산
    component hashUser = Poseidon(1);
    hashUser.inputs[0] <== userIdRaw;
    signal userIdHash;
    userIdHash <== hashUser.out;

    // 허용 리스트 해시들
    signal allowedHash[N];
    component hashList[N];

    for (var i = 0; i < N; i++) {
        hashList[i] = Poseidon(1);
        hashList[i].inputs[0] <== allowedRawList[i];
        allowedHash[i] <== hashList[i].out;
    }

    // Equality check
    signal eqResult[N];
    component eqCheck[N];

    for (var i = 0; i < N; i++) {
        eqCheck[i] = IsEqual();
        eqCheck[i].in[0] <== userIdHash;
        eqCheck[i].in[1] <== allowedHash[i];
        eqResult[i] <== eqCheck[i].out;
    }

    // MultiOR(N) → 하나라도 일치하면 통과
    component or = MultiOR(N);
    for (var i = 0; i < N; i++) {
        or.in[i] <== eqResult[i];
    }

    // 중간값 auth에 저장
    signal auth <== or.out;

    // Boolean 제약: auth ∈ {0,1}
    signal diff <== auth * (auth - 1);
    component isZero = IsZero();
    isZero.in <== diff;
    // enforce diff == 0
    isZero.out === 1;

    // 최종 output
    isAuthorized <== auth;
}

component main = ZKDIDVerify(5); // 허용 리스트 크기 = 5
