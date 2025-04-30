pragma circom 2.0.0;

  include "../../circom/circomlib/circuits/comparators.circom";

template MaxN (n) {
  signal input in[n];
  signal output max;

  signal temp[n];       // 중간 최대값 저장용

  temp[0] <== in[0];     // 초기값
  component cmp[n-1];  // 비교기 배열 미리 선언 - 이런 코드는 런타임적으로 변하는 구조라서 "컴파일 타임에 회로 크기를 고정할 수 없음" → 그래서 Circom은 모든 회로 컴포넌트를 반복문 전에 배열로 선언해야만 해.
  
  signal sel_a[n];  //최대값 판별용
  signal sel_b[n];  //최대값 판별용

  for (var i = 1; i < n; i++) {  
    cmp[i - 1] = GreaterThan(32);
    cmp[i - 1].in[0] <== in[i];
    cmp[i - 1].in[1] <== temp[i - 1];

    // 최대값 선택
    sel_a[i] <== cmp[i - 1].out * in[i];
    sel_b[i] <== (1 - cmp[i - 1].out) * temp[i - 1];
    temp[i] <== sel_a[i] + sel_b[i];
  }

  max <== temp[n - 1];   // 마지막이 최종 최대값
}

component main = MaxN(10);