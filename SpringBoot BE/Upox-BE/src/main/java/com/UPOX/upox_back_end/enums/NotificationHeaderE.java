package com.UPOX.upox_back_end.enums;

public enum NotificationHeaderE {
    MONTH_BEFORE("Còn 1 tháng - có người quên sử dụng đồ kìa \uD83D\uDE24"),
    SEVEN_DAYS_BEFORE("Còn 7 ngày - dùng mau mau, không kịp đâu! \uD83D\uDE21"),
    THREE_DAYS_BEFORE("Còn 3 ngày - DÙNG NGAY!!! \uD83D\uDD25\uD83D\uDD25\uD83D\uDD25"),
    SPOILT("Oh no! không ổn rồi \uD83D\uDE31"),
    SPEND_TOO_MUCH("SOS! Bạn đang tiêu xài quá tay \uD83D\uDE21")
    ;
    String title;
    NotificationHeaderE(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}
