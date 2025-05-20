pragma circom 2.0.0;

include "../../../circom/circomlib/circuits/comparators.circom";

template ArrayEqual (n) {
  signal input a[n];
  signal input b[n];
  signal output isEqual;

  // 실제로 각 배열의 원소가 같은지 확인 결과 저장하는 배열
  signal eqBits[n];
  // 각 배열의 원소를 IsEqual 함수로 비교하는 비교기 배열
  component eq[n];

  for(var i = 0; i < n; i++){
    eq[i] = IsEqual();
    eq[i].in[0] <== a[i];
    eq[i].in[1] <== b[i];
    eqBits[i] <== eq[i].out;
  }

  //중간 signal을 도입해서 누적 계산 분리 - eqBits의 n개의 결과를 보관하면서도 초기값 초기화하기 위해 n+1
  signal result[n + 1];
  // 중간 signal의 초기값 설정
  result[0] <== 1;

  for (var i = 0; i < n; i++) {
    result[i + 1] <== result[i] * eqBits[i];
  }
  ㄴ
  isEqual <== result[n];
}

component main = ArrayEqual(10);