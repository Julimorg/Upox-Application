package com.UPOX.upox_back_end.enums;

public enum NotificationBodyE {
    MONTH_BEFORE("Trong 1 tháng nữa thôi, UPOX lo rằng bạn sẽ không dùng kịp - productName"),
    SEVEN_DAYS_BEFORE("Trong 7 ngày nữa thôi, UPOX lo rằng bạn sẽ không dùng kịp - productName"),
    THREE_DAYS_BEFORE("Trong 3 ngày nữa thôi, UPOX lo rằng bạn sẽ không dùng kịp - productName"),
    SPOILT("UPOX lo lắng khi nhắc bạn rằng - productName - đã hết hạn sử dụng vào ngày hôm nay. Hãy xử lý chúng thật an toàn và vệ sinh nhé."),
    SPEND_TOO_MUCH("Bạn đã tiêu xài quá tay rồi, mau mau kiểm tra lại chi tiêu thôi.")
    ;
    String content;
    String productName = "";

    NotificationBodyE(String content) {
        this.content = content;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content){
        this.content = content;
    }

    public void updateContent() {
        String[] contents = this.content.split("-",3);
        String mainContent = contents[0];
        this.content = mainContent + this.productName;
        if(contents.length > 2){
            String subContent = contents[2];
            this.content += subContent;
        }
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

}
