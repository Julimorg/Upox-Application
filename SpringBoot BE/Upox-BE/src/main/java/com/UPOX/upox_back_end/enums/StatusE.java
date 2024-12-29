package com.UPOX.upox_back_end.enums;

public enum StatusE {
    NORMAL(1),
    MONTH_BEFORE(2),
    SEVEN_DAYS_BEFORE(3),
    THREE_DAYS_BEFORE(4),
    LATE(5),
    SPOILT(6),
    ;

    int weight;


    StatusE(int weight) {
        this.weight = weight;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }
}
