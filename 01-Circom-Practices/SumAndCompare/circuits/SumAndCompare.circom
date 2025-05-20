pragma circom 2.0.0;

include "./SumN.circom";
include "../../../circom/circomlib/circuits/comparators.circom";  // 비교기 포함

template SumAndCompare(n, threshold) {

  signal input in[n]; // 배열 입력
  signal output isValid; // 합 ≤ threshold → 1, 아니면 0

  component summer = SumN(n);
  for (var i = 0; i < n; i++){
    summer.in[i] <== in[i];
  }

  component checker = LessThan(32);
  checker.in[0] <== summer.out;
  checker.in[1] <== threshold;

  isValid <== checker.out;
}

component main = SumAndCompare(5, 50);
