pragma circom 2.0.0;

include "../../circom/circomlib/circuits/poseidon.circom";
include "../../circom/circomlib/circuits/comparators.circom";
include "./MultiOR.circom";

//ZK 기반 국제 컨퍼런스 입장 자격 인증 시스템
// 참가자: 최소 18세 이상, 역할 : 연사, 조직위원, VIP 게스트 중 하나,
//국가 :대한민국, 미국, 독일, 영국, 프랑스 중 하나일 때만 입장이 허용됨.
template ZKRoleVerify(N, M) {
  signal input userAge;
  signal input userRole;
  signal input userCountry;

  signal input minAgeRequired;
  signal input requiredRole[N];
  signal input allowedCountries[M];

  signal output isAuthorized;

// 조건: userAge ≥ minAgeRequired
  // LessThen minAgeRequired check
  signal LessThanResult;
  component LessThanCheck;
  LessThanCheck = LessThan(32);
  LessThanCheck.in[0] <== userAge;
  LessThanCheck.in[1] <== minAgeRequired;
  LessThanResult <== LessThanCheck.out;


//조건: userRole == requiredRole
  // 사용자 역할 해시 계산
  component hashUserRole = Poseidon(1);
  hashUserRole.inputs[0] <== userRole;
  signal userRoleHash <== hashUserRole.out;

  // 필요 역할 리스트 해시들 계산
  signal requiredRoleHash[N];
  component R_hashList[N];

  for (var i = 0; i < N; i++) {
    R_hashList[i] = Poseidon(1);
    R_hashList[i].inputs[0] <== requiredRole[i];
    requiredRoleHash[i] <== R_hashList[i].out;
  }

  // Equality check
  signal R_eqResult[N];
  component R_eqCheck[N];
  for (var i = 0; i < N; i++) {
    R_eqCheck[i] = IsEqual();
    R_eqCheck[i].in[0] <== userRoleHash;
    R_eqCheck[i].in[1] <== requiredRoleHash[i];
    R_eqResult[i] <== R_eqCheck[i].out;
  }
  
  // MultiOR(N) → 필요 역할 중 하나라도 일치하면 통과
  component R_or = MultiOR(N);
  for (var i = 0; i < N; i++) {
    R_or.in[i] <== R_eqResult[i];
  }

//조건: userCountry == allowedCountries
  // 사용자 국가 해시 계산
  component hashUserCountry = Poseidon(1);
  hashUserCountry.inputs[0] <== userCountry;
  signal userCountryHash <== hashUserCountry.out;

  // 허용 국가 리스트 해시들 계산
  signal allowedCountriesHash[M];
  component C_hashList[M];

  for (var i = 0; i < M; i++) {
    C_hashList[i] = Poseidon(1);
    C_hashList[i].inputs[0] <== allowedCountries[i];
    allowedCountriesHash[i] <== C_hashList[i].out;
  }

  // Equality check
  signal C_eqResult[M];
  component C_eqCheck[M];
  
  for (var i = 0; i < M; i++) {
    C_eqCheck[i] = IsEqual();
    C_eqCheck[i].in[0] <== userCountryHash;
    C_eqCheck[i].in[1] <== allowedCountriesHash[i];
    C_eqResult[i] <== C_eqCheck[i].out;
  }

  // MultiOR(M) → 허용 국가 중 하나라도 일치하면 통과
  component C_or = MultiOR(M);
  for (var i = 0; i < M; i++) {
    C_or.in[i] <== C_eqResult[i];
  }

  // 두 조건 모두 충족해야 isAuthorized = 1
  //Circom의 핵심 제약 중 하나 : "제약식은 반드시 2차식(quadratic) 형태만 허용"
  // >> 3차식 2개의 2차식으로 나누어 계산
  signal temp1;
  signal temp2;

  temp1 <== (1 - LessThanResult) * R_or.out;
  temp2 <== temp1 * C_or.out;
  signal auth <== temp2;

  // Boolean 제약: auth ∈ {0,1}
  signal diff <== auth * (auth - 1);
  component isZero = IsZero();
  isZero.in <== diff;
  // enforce diff == 0
  isZero.out === 1;

  isAuthorized <== auth;
}

component main = ZKRoleVerify(3, 5);
