package com.UPOX.upox_back_end.model;

public class EmailForm {
    private String recipient;
    private String otpCode;
    private String subject;

    public EmailForm(){}

    public EmailForm(String recipient, String otpCode, String subject) {
        this.recipient = recipient;
        this.otpCode = otpCode;
        this.subject = subject;
    }

    public String getRecipient() {
        return recipient;
    }

    public void setRecipient(String recipient) {
        this.recipient = recipient;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    @Override
    public String toString() {
        return "EmailForm{" +
                "recipient='" + recipient + '\'' +
                ", otpCode='" + otpCode + '\'' +
                ", subject='" + subject + '\'' +
                '}';
    }
}
