package com.UPOX.upox_back_end.configuration;

import com.UPOX.upox_back_end.enums.Role;
import com.UPOX.upox_back_end.service.AuthenticateService;
import com.nimbusds.jose.JWSAlgorithm;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import javax.crypto.spec.SecretKeySpec;
import java.io.IOException;

@Configuration
//Các class chứa annotation @Configuration sẽ thông báo cho Spring init lên những public method có
//annotation @Bean
@EnableWebSecurity
@EnableMethodSecurity
@Slf4j
//@RequiredArgsConstructor
public class SecurityConfig {

//    @Autowired
//    private final AuthenticateService service;

    public final String[] PUBLIC_ENDPOINTS = {
            "/users", //ĐĂNG KÝ
            "/api/v1/auth/log-in", //ĐĂNG NHẬP
            "/api/v1/auth/activate", //KÍCH HOẠT TÀI KHOẢN
            "/api/v1/auth/introspect", //XÉT TOKEN
            "/api/v1/auth/log-out", //LOG OUT
            "/api/v1/auth/refresh-token", //REFRESH TOKEN
            "/users/forget-password/{userId}", //FORGET PASSWORD
            "/api/v1/auth/{userId}", //ACTIVATE ACCOUNT
            "/api/v1/auth/send-mail/{userGmail}", //FORGET PASS SEND MAIL VERIFY
            "/api/v1/auth/google-login", //GOOGLE LOGIN
    };

    public final String[] MUST_ADMIN_ENDPOINTS = {
        "/users", //GET METHOD
    };



    @Value("${jwt.secret.key}")
    private String SECRET;

    @Autowired
    private CustomJwtDecoder customJwtDecoder;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity httpSecurity) throws Exception {
        //Khai báo những endpoint cần bảo vệ, những endpoint nào mà user được phép truy cập

        //CÁC END POINT ĐƯỢC PHÉP TRUY CẬP


        httpSecurity.authorizeHttpRequests(httpSecurityRequest ->
                httpSecurityRequest.requestMatchers(HttpMethod.POST,PUBLIC_ENDPOINTS).permitAll()
                        .requestMatchers(HttpMethod.PUT,PUBLIC_ENDPOINTS).permitAll()
                        .requestMatchers(HttpMethod.GET,PUBLIC_ENDPOINTS).permitAll()
//                        .requestMatchers(HttpMethod.GET,"/users").hasAuthority("SCOPE_ADMIN")
                        .anyRequest().authenticated()); //parameters: method, end-point

        //AUTHENTICATION PROVIDER
        httpSecurity.oauth2ResourceServer(oauth2Config -> //Đăng ký Authentication Provider để xử lý JWT token
                //Khi phát hiện request có gửi kèm token
                //System sẽ call đến đây để xử lý token đó
                oauth2Config.jwt(jwtConfigurer ->
                        //Câu hình JWT decoder để decode token --> tự động verify
                        //Chưa có authorization, tất cả các users (có valid token) đều request được
                            jwtConfigurer.decoder(customJwtDecoder) //Truyền token vào
                )
        );


        //FORBIDDEN
        //CSRF: Bảo vệ end-point trước attack (Cross-Site Request Forgery)
        httpSecurity.csrf(httpSecurityCsrf -> httpSecurityCsrf.disable());


        //CÁC END POINT CẦN BẢO VỆ
        return httpSecurity.build();
    }

//    @Bean
//    JwtDecoder jwtDecoder(){ //Cung cấp JWT decoder để giải mã
//        SecretKeySpec _secretKeySpec = new SecretKeySpec(SECRET.getBytes(),"HS512");
//        NimbusJwtDecoder nimbusJwtDecoder = NimbusJwtDecoder
//                .withSecretKey(secretKeySpec)
//                .macAlgorithm(MacAlgorithm.HS512)
//                .build();
//        return new JwtDecoder() {
//            @Override
//            public Jwt decode(String token)  {
//                try{
//                    log.warn("token: " + token);
//                    //Introspect trước:
//
//                    //Nếu token hết hạn: gọi refresh token
//                    Jwt _jwt = nimbusJwtDecoder.decode(token);
//                    log.warn("jwt: " + jwt);
//                    return jwt;
//                } catch (JwtException jwtException){
//                    log.warn(jwtException.getMessage());
////                    log.warn(jwtException.getCause().toString());
//                    throw jwtException;
//                }
//            }
//        };
//    }

    @Bean
    PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder(10);
    }
}
