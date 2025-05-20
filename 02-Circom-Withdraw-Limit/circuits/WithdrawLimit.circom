pragma circom 2.0.0;

include "../../circom/circomlib/circuits/comparators.circom";

template WithdrawLimit() {
    signal input balance_before;
    signal input withdraw_amount;
    signal input balance_after;

    signal output isValid;

    signal computed;
    signal difference;
    signal isCorrectBalance;
    signal withinLimit;

    computed <== balance_before - withdraw_amount;
    difference <== computed - balance_after;

    // Equality comparator: difference == 0
    component isZero = IsEqual();
    isZero.in[0] <== difference;
    isZero.in[1] <== 0;
    isCorrectBalance <== isZero.out;

    // LessThan comparator: withdraw_amount < 51
    component cmp = LessThan(32);
    cmp.in[0] <== withdraw_amount;
    cmp.in[1] <== 51;
    withinLimit <== cmp.out;

    isValid <== isCorrectBalance * withinLimit;
}

component main = WithdrawLimit();
