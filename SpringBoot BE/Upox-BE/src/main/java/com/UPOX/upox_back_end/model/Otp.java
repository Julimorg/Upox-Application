package com.UPOX.upox_back_end.model;

public class Otp {
    private String otp;
    private String expiredOtp;

    public Otp() {
    }
    public Otp(String otp, String expiredOtp) {
        this.otp = otp;
        this.expiredOtp = expiredOtp;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getExpiredOtp() {
        return expiredOtp;
    }

    public void setExpiredOtp(String expiredOtp) {
        this.expiredOtp = expiredOtp;
    }
}
