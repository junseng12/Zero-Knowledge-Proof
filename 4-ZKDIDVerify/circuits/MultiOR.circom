pragma circom 2.0.0;

include "../../circom/circomlib/circuits/comparators.circom";

template MultiOR(N){
  signal input in[N];
  signal output out;

  signal acc[N];
  
  acc[0] <== in[0];
  for(var i = 1; i < N; i++)
    acc[i] <== acc[i-1] + in[i];
  
  component isZero = IsEqual();
  isZero.in[0] <== acc[N-1];
  isZero.in[1] <== 0;

  out <== 1 - isZero.out;
}