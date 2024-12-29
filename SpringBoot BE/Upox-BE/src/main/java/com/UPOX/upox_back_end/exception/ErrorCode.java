package com.UPOX.upox_back_end.exception;

public enum ErrorCode {
    USER_EXISTED(401, "Tên đăng nhập đã tổn tại"),
    UNCATEGORIZED_EXCEPTION(400,"Lỗi không xác định"),
    PASSWORD_WORDS_NOT_ENOUGH(402,"Mật khẩu phải từ 8 - 15 ký tự"),
    PASSWORD_WITHOUT_CAPITAL(403,"Chứa ít nhất 1 ký tự in hoa"),
    INVALID_KEY(405,"Không tìm thấy error key"),
    GMAIL_NOT_EXISTED(406,"Gmail không tồn tại"),
    INVALID_GMAIL(407,"Gmail không hợp lệ"),
    USER_NOT_EXISTED(408,"Người dùng không tồn tại"),
    USER_NOT_AUTHENTICATED(401, "Người dùng chưa được xác thực"),
    USER_NOT_AUTHORIZED(403, "Người dùng chưa được uỷ quyền"),
    TOKEN_IS_EXPIRED(409, "Token hết hạn"),


    ; //Define các Error code


    ErrorCode(int code, String message) {
        this.code = code;
        this.message = message;
    }

    private int code;
    private String message;
    public int getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
