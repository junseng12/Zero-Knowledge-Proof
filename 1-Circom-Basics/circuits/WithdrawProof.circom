template WithdrawProof() {
    signal input balance_before;
    signal input withdraw_amount;
    signal input balance_after;

    signal output isValid;

    signal computed;
    signal difference;

    // 출금 후 잔액 계산
    computed <== balance_before - withdraw_amount;

    // difference 계산
    difference <== computed - balance_after;

    // difference가 0이면 같다는 뜻 → isValid = 1
    isValid <-- 1 - (difference != 0);
}

component main = WithdrawProof();
