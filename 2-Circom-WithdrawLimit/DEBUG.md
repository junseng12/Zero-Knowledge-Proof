# 🐞 DEBUG – WithdrawLimit Circom 실습 중 발생한 오류 정리

---

## 1. Circom 설치 및 실행 문제
- ❌ `npm run build` 실패 → circom은 정식 릴리스 npm 패키지가 아니며, GitHub에서 직접 clone 후 Rust build 필요
- 🔧 해결: `git clone`, `cargo build --release`, PATH 등록

---

## 2. LessThan, IsEqual 불러오기 오류
- ❌ include 경로 오류 (`ENOENT: no such file`)
- 🔧 해결: circom 실행 시 `--include ../circomlib/circuits` 명시

---

## 3. 회로 표현 오류
- ❌ `difference === 0` → Circom 2.0에서는 비교 연산자 사용 불가
- 🔧 해결: `IsEqual()` 컴포넌트 사용하여 대체

---

## 4. public[0] 검증이 항상 OK
- 🔍 snarkJS는 회로 자체의 유효성을 검증할 뿐, 회로 내 `isValid` 값이 0이어도 OK로 처리됨
- ✅ 해결: 스마트컨트랙트 혹은 오프체인 로직에서 public 값 확인 추가

---

## 5. 파일 구조 문제
- ❌ 기존 build 폴더와 겹쳐서 혼란
- 🔧 해결: 실습 폴더 구조를 `1-Circom-Basics`, `2-Circom-WithdrawLimit` 등으로 분리 운영

---

# 🧰 기타 팁
- Circom 에러 메시지는 `Parse error`, `Missing semicolon` 등 정적 문법 검사 중심
- Circom 2.0은 TypeScript 컴파일 대신 Rust 기반 바이너리로 실행됨