pragma circom 2.0.0;

template SumN(n) {
  signal input in[n];
  signal output out;

  signal sum[n]; //중간 누적용 신호
  var i;
  
  sum[0] <==in[0];
  for (i = 1; i < n; i++){
    sum[i] <== sum[i-1] + in[i];
  }

  out <== sum[n-1]; // out은 단 1번만 constraint로 연결
}

component main = SumN(6);