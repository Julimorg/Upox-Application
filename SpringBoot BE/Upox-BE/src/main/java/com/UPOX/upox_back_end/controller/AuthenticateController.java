package com.UPOX.upox_back_end.controller;

import com.UPOX.upox_back_end.dto.request.*;
import com.UPOX.upox_back_end.dto.response.*;
import com.UPOX.upox_back_end.entity.User;
import com.UPOX.upox_back_end.exception.ErrorCode;
import com.UPOX.upox_back_end.model.Otp;
import com.UPOX.upox_back_end.service.AuthenticateService;
import com.UPOX.upox_back_end.service.UserService;
import com.google.protobuf.Api;
import com.nimbusds.jose.JOSEException;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpRequest.BodyPublisher;

import java.net.http.HttpResponse;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.awt.Desktop;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

@RestController
@RequestMapping(path = "/api/v1/auth")
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class AuthenticateController {

    AuthenticateService authenticateService;
    UserService userService;

    @GetMapping("send-mail/{userGmail}")
    Object getOtpForChangePassWord(@PathVariable("userGmail") String userGmail){
        //đã có tài khoản rồi
        //trả về:
        //OTP: OTP code
        //ExpiredOTP: OTP sẽ đổi thành mã này sau 5p, nhằm mục đích vô hiệu hoá mã cũ
        //Gôm vào Api response
        if(!userService.isEmailExisted(userGmail)){
            ApiResponse apiResponse = new ApiResponse();
            apiResponse.setSucceed(false);
            apiResponse.setStatusCode(ErrorCode.GMAIL_NOT_EXISTED.getCode());
            apiResponse.setMessage(ErrorCode.GMAIL_NOT_EXISTED.getMessage());
            return ResponseEntity.badRequest().body(apiResponse);
        }
        else{
            Otp otpResponse = authenticateService.getOtpResponse();
            authenticateService.sendMail(userGmail,otpResponse.getOtp());
            ApiResponse<Otp> apiResponse = new ApiResponse<>();
            apiResponse.setResult(otpResponse);
            return apiResponse;
        }
    }

    @PutMapping("/{userId}")
    ApiResponse<Otp> activateAccountByOtp(@PathVariable("userId") String userId, @RequestBody @Valid UserUpdateRequest objRequest){
        //Cập nhật mail user vào database
        System.out.println(objRequest);

        UserResponse activatedUser = userService.updateRequest(userId,objRequest);
        Otp otpResponse = authenticateService.getOtpResponse();
        //Gửi mail
        authenticateService.sendMail(activatedUser.getEmail(), otpResponse.getOtp());
        ApiResponse<Otp> apiResponse = new ApiResponse<>();
        apiResponse.setResult(otpResponse);
        return apiResponse;
    }

    @PostMapping("/log-in")
    ApiResponse<AuthenticateResponse> authenticate(@RequestBody AuthenticateRequest authenticateRequest){
        var result = authenticateService.authenticate(authenticateRequest); //Nhập đúng tài khoản mật khẩu
        ApiResponse<AuthenticateResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(result);
        if(result == null){
            apiResponse.setMessage("Tài khoản chưa được kích hoạt");
        }

        return apiResponse;
    }

    @PostMapping("/activate")
    ApiResponse<AuthenticateResponse> activate (@RequestBody ActivateRequest activateRequest){
        var result = authenticateService.activate(activateRequest); //Xác nhận đã kích hoạt tài khoản chưa?
        ApiResponse<AuthenticateResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(result);

        return apiResponse;
    }

    @PostMapping("/log-out")
    ApiResponse<AuthenticateResponse> logOut (@RequestBody LogoutRequest logoutRequest)
            throws ParseException, JOSEException {
        authenticateService.invalidateToken(logoutRequest); //Xác nhận đã kích hoạt tài khoản chưa?
        ApiResponse<AuthenticateResponse> apiResponse = new ApiResponse<>();
        return apiResponse;
    }

    @PostMapping("/introspect")
    ApiResponse<IntrospectResponse> introspect(@RequestBody IntrospectRequest introspectRequest)
            throws ParseException, JOSEException {
        var result = authenticateService.introspect(introspectRequest);
        ApiResponse<IntrospectResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(result);

        return apiResponse;
    }

    @PostMapping("/refresh-token")
    ApiResponse<AuthenticateResponse> updateAccessToken(@RequestBody RefreshTokenRequest refreshTokenRequest)
            throws JOSEException, ParseException {
        var result = authenticateService.updateAccessToken(refreshTokenRequest);
        ApiResponse<AuthenticateResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(result);

        return apiResponse;
    }

    @PostMapping("/google-signUp")
    ApiResponse<GoogleUserResponse> googleSignUp(@RequestBody GoogleLoginRequest googleSignUpRequest) throws GeneralSecurityException, IOException {
        var result = authenticateService.googleSignUp(googleSignUpRequest);
        ApiResponse<GoogleUserResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(result);

        return apiResponse;
    }

    @PostMapping("/google-login")
    ApiResponse<AuthenticateResponse> googleLogin(@RequestBody GoogleLoginRequest googleLoginRequest){

        var res = authenticateService.googleLogin(googleLoginRequest);

        ApiResponse<AuthenticateResponse> apiResponse = new ApiResponse<>();
        apiResponse.setResult(res);

        return apiResponse;
    }
}
