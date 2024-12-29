package com.UPOX.upox_back_end.service;

import com.UPOX.upox_back_end.dto.request.*;
import com.UPOX.upox_back_end.dto.response.AuthenticateResponse;
import com.UPOX.upox_back_end.dto.response.GoogleUserResponse;
import com.UPOX.upox_back_end.dto.response.IntrospectResponse;
import com.UPOX.upox_back_end.dto.response.UserResponse;
import com.UPOX.upox_back_end.entity.GoogleToken;
import com.UPOX.upox_back_end.entity.InvalidateToken;
import com.UPOX.upox_back_end.entity.User;
import com.UPOX.upox_back_end.enums.Role;
import com.UPOX.upox_back_end.exception.ErrorCode;
import com.UPOX.upox_back_end.model.EmailForm;
import com.UPOX.upox_back_end.model.Mapper;
import com.UPOX.upox_back_end.model.Otp;
import com.UPOX.upox_back_end.repository.GoogleTokenRepository;
import com.UPOX.upox_back_end.repository.InvalidateTokenRepository;
import com.UPOX.upox_back_end.repository.UserRepository;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jwt.JWTClaimNames;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import jakarta.mail.internet.MimeMessage;
import lombok.AccessLevel;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.antlr.v4.runtime.Token;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMailMessage;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import org.springframework.util.CollectionUtils;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.chrono.ChronoPeriod;
import java.time.chrono.Chronology;
import java.time.temporal.TemporalUnit;
import java.util.*;
import java.time.temporal.*;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;

@Service
@Slf4j
public class AuthenticateService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JavaMailSender javaMailSender;
    @Autowired
    private TemplateEngine templateEngine;
    @Autowired
    private InvalidateTokenRepository invalidateTokenRepository;
    @Autowired
    private GoogleTokenRepository googleTokenRepository;


    @NonFinal //Secret key để generate signature
    @Value("${jwt.secret.key}")
    protected String SECRET;


    @NonFinal
    @Value("${spring.mail.username}")
    String sender;


    @NonFinal //Secret key để generate signature
    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    protected String CLIENT_ID;


    public void sendMail(String recipient, String otpCode){
        try{
            String otp = otpCode.replace(""," ").trim();
            System.out.println(otp);

            EmailForm emailForm = new EmailForm(recipient,otp,"Cho chúng tôi biết đây là bạn.");
            Context context = new Context();
            context.setVariable("otpCode",otp);


            String htmlForm = templateEngine.process("htmlForm",context); //Lâu ở render mail


            MimeMessage mailMessage = javaMailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mailMessage,true);
            helper.setFrom(sender);
            helper.setTo(emailForm.getRecipient());
            helper.setSubject(emailForm.getSubject());
            helper.setText(htmlForm,true);

            javaMailSender.send(mailMessage);  //Lâu ở gửi mail

        }catch (Exception ex){
            System.out.println("Gửi không thành công!");
        }
    }

    public Otp getOtpResponse(){
        String otp = generateOtp();
        String expiredOtp = generateExpiredOtp();
        return new Otp(otp,expiredOtp);
    }

    private String getRandomString(String keyEnv){
        String SALTCHARS = keyEnv;
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < 4) { // length of the random string.
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        String randStr = salt.toString();
        return randStr;
    }

    private String generateOtp(){
        String otp = getRandomString("1234567890");
        return otp;
    }
    private String generateExpiredOtp(){
        String expiredOtp = getRandomString("ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890");
        return expiredOtp;
    }

    public AuthenticateResponse activate(ActivateRequest request){ //This is for SignUp
        var user =  userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException(ErrorCode.USER_NOT_EXISTED.getMessage()));
        if(!request.isOtpVerified() || user.getEmail().isEmpty()){ //Có nhập mail và xác thực OTP thành công
            throw new RuntimeException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage());
        }

        //Activate account
        user.setActivated(true);
        userRepository.save(user);


        //Generate token
        var accessToken = generateToken(user,false);
        var refreshToken = generateToken(user, true);
        return AuthenticateResponse.builder()
                .authenticated(true)
                .token(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    public AuthenticateResponse authenticate(AuthenticateRequest request){ //This is for login
        var user =  userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new RuntimeException(ErrorCode.USER_NOT_EXISTED.getMessage()));

        if(!user.isActivated()){
            return null;
        }

        //Xét password có trùng nhau không
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        boolean isAuthenticated = passwordEncoder.matches(request.getPassword(), user.getPassword());

        //Đăng nhập sai
        if(!isAuthenticated){
            throw new RuntimeException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage());
        }

        //Revoke token cũ (Khoá đăng nhập trên nhiều thiết bị)


        //Đăng nhập đúng --> cấp token
        var accessToken = generateToken(user,false);
        var refreshToken = generateToken(user, true);

        return AuthenticateResponse.builder()
                .authenticated(true)
                .token(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private String generateToken(User user, boolean isRefreshToken){
        //Header
        JWSHeader jwtHeader = new JWSHeader(JWSAlgorithm.HS512);


        //Payload
        //Data trong body gọi là claim
        LocalDateTime expiration = LocalDateTime.now(); //Set expiry date
        Date convertedExpiredDateAccessToken = Date.from(expiration.plusHours(1).atZone(ZoneId.systemDefault()).toInstant());

        Date convertedExpiredDateRefreshToken = Date.from(expiration.plusYears(1).atZone(ZoneId.systemDefault()).toInstant());

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(user.getUsername())
                .issuer("UPOX.com")   //Được gửi/issue từ ai (thường là domain của business)
                .issueTime(new Date())
                .expirationTime(isRefreshToken? convertedExpiredDateRefreshToken : convertedExpiredDateAccessToken)
                .jwtID(UUID.randomUUID().toString())
                .claim("userId", user.getId())
                .claim("scope", buildScope(user))
                .build();

        Payload jwtPayLoad = new Payload(jwtClaimsSet.toJSONObject());

        JWSObject jwsObject = new JWSObject(jwtHeader,jwtPayLoad);


        //Signature
        //Khoá để ký - Khoá giải mã trùng nhau: Symmetric Encryption
        //Khoá để ký - Khoá public để verify: Asymmetric Encryption

        try {
            jwsObject.sign(new MACSigner(SECRET.getBytes()));
            return jwsObject.serialize();
        } catch (JOSEException e) {
            System.out.println("Cannot create token");
            throw new RuntimeException(e);
        }
    }

    private String buildScope(User user){
        //THEO OAUTH2: CÁC ROLE CÁC NHAU BẰNG " " /SPACE
        StringJoiner stringJoiner = new StringJoiner(" ");
        if(!CollectionUtils.isEmpty(user.getRoles())){ //Nếu User này có role
            user.getRoles().forEach(role -> stringJoiner.add(role));
        }
        return stringJoiner.toString();
    }

    private SignedJWT verifyToken(String token) throws JOSEException, ParseException {
        JWSVerifier verifier = new MACVerifier(SECRET.getBytes());
        SignedJWT signedJWT = SignedJWT.parse(token);

        //Check verification
        boolean isTokenVerified = signedJWT.verify(verifier);

        //Check date expiration
        Date expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();
        boolean isTokenStillValid = expiryTime.after(new Date());


        if(!(isTokenVerified && isTokenStillValid)){
            throw new RuntimeException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage());
        }

        //tokenId
        //check is invalidated (revoked)
        String jit = signedJWT.getJWTClaimsSet().getJWTID();
        boolean isInvalidated =  invalidateTokenRepository.existsById(jit);

        if(isInvalidated){
            throw new RuntimeException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage());
        }

        return signedJWT;
    }

    public IntrospectResponse introspect(IntrospectRequest request) throws JOSEException, ParseException {
        var token = request.getToken();
        boolean isTokenValid = true;

        //verify
//        JWSVerifier verifier = new MACVerifier(SECRET.getBytes());
//        SignedJWT signedJWT = SignedJWT.parse(token);
//        boolean isTokenVerified = signedJWT.verify(verifier);
//
//        Date expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();
//        boolean isTokenStillValid = expiryTime.after(new Date());

        try{
            SignedJWT signedJWT = verifyToken(token);
        }catch (Exception ex){
            isTokenValid = false;
        }

        return IntrospectResponse.builder()
                .valid(isTokenValid)
                .build();
    }

    public void invalidateToken(LogoutRequest request) throws JOSEException, ParseException {
        //Context (1): Khi đăng nhập trên thiết bị khác cùng là user, thì token cũ sẽ bị revoked
        //Và generate token mới cho thiết bị mới --> Được lưu đè lên token cũ trên FE

        //Context (2): Log out --> FE cũng delete luôn token cũ

        var token = request.getToken();

        SignedJWT signedJWT = verifyToken(token);

        //tokenId
        String jit = signedJWT.getJWTClaimsSet().getJWTID();
        Date expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();

        InvalidateToken invalidateToken = InvalidateToken.builder()
                .id(jit)
                .expiredDate(expiryTime)
                .build();

        invalidateTokenRepository.save(invalidateToken);
    }



    public AuthenticateResponse updateAccessToken(RefreshTokenRequest request) throws JOSEException, ParseException {
        //Lấy các token ra
        String oldAccessToken = request.getAccessToken();

        //Check thông tin access token (điều kiện: phải là token của hệ thống)

        JWSVerifier verifier = new MACVerifier(SECRET.getBytes());
        SignedJWT signedJWT = SignedJWT.parse(oldAccessToken);

        //Check verification
        boolean isTokenVerified = signedJWT.verify(verifier);

        //Check date expiration
        Date expiryTime = signedJWT.getJWTClaimsSet().getExpirationTime();
        boolean isTokenStillValid = expiryTime.after(new Date());

        if(!isTokenVerified){
            throw new RuntimeException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage());
        }


        //Check refresh token có hợp lệ không?
        String refreshToken = request.getRefreshToken();

        SignedJWT signedRefreshJWT = verifyToken(refreshToken);
        String userId = signedRefreshJWT.getJWTClaimsSet().getStringClaim("userId");

        User user = userRepository.findById(userId).orElseThrow(
                () -> new RuntimeException(ErrorCode.USER_NOT_EXISTED.getMessage()));

        String newAccessToken = generateToken(user,false);

        log.warn("Old token: " + oldAccessToken + "\nNew token: " + newAccessToken);


        return AuthenticateResponse.builder()
                .authenticated(true)
                .token(newAccessToken)
                .refreshToken(refreshToken)
                .build();
    }

    private Mapper userMapper = new Mapper();
    public GoogleUserResponse googleSignUp(GoogleLoginRequest request) throws GeneralSecurityException, IOException {
        String email = request.getEmail();
        boolean emailVerified = request.isVerified();
        String name = request.getUsername();
        String pictureUrl = request.getPicture();
        String locale = request.getLocale();
        String familyName = request.getFamilyName();
        String givenName = request.getGivenName();
        String googleTokenRequest = request.getGoogleToken();

        //Basic info
        User newUser = new User();
        newUser.setUsername(name);
        newUser.setEmail(email);
        newUser.setFirstName(familyName);
        newUser.setLastName(givenName);
        newUser.setActivated(true);
        newUser.setGoogleLogin(true);

        //Google Token
        GoogleToken googleToken = GoogleToken.builder()
                .token(googleTokenRequest)
                .build();

        //Role
        HashSet<String> roles = new HashSet<>(); //Tạo thành một Set
        roles.add(Role.USER.name());
        newUser.setRoles(roles);

        //User
        userRepository.save(newUser);
        userRepository.flush();

        googleToken.setUser(newUser);

        //Google Token
        googleTokenRepository.save(googleToken);
        googleTokenRepository.flush();


        UserResponse userResponse = userMapper.toUserResponse(newUser);

        var accessToken = generateToken(newUser,false);
        var refreshToken = generateToken(newUser, true);
        var authenticationResponse =  AuthenticateResponse.builder()
                                .authenticated(true)
                                .token(accessToken)
                                .refreshToken(refreshToken)
                                .build();

        return GoogleUserResponse.builder()
                .userResponse(userResponse)
                .authenticateResponse(authenticationResponse)
                .build();
    }

    public AuthenticateResponse googleLogin(GoogleLoginRequest request){
        try{
            String userId = request.getUserId();
            var currentUser = userRepository.findById(userId); //Có user này tồn tại
            assert currentUser.orElse(null) != null;

            if(currentUser.get().isGoogleLogin()){ //User này là google user
                String token = request.getGoogleToken();
                GoogleToken googleToken = currentUser.get().getGoogleTokens().get(0);
                googleToken.setToken(token);
                googleTokenRepository.save(googleToken);
                googleTokenRepository.flush();

                var accessToken = generateToken(googleToken.getUser(),false);
                var refreshToken = generateToken(googleToken.getUser(), true);
                return AuthenticateResponse.builder()
                        .authenticated(true)
                        .token(accessToken)
                        .refreshToken(refreshToken)
                        .build();
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

//    private void googleVerify(String idTokenString) throws GeneralSecurityException, IOException {
//
//        log.warn("user google token: " + idTokenString);
//
//        GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), new GsonFactory())
//                // Specify the CLIENT_ID of the app that accesses the backend:
//                .setAudience(Collections.singletonList(CLIENT_ID))
//                // Or, if multiple clients access the backend:
//                //.setAudience(Arrays.asList(CLIENT_ID_1, CLIENT_ID_2, CLIENT_ID_3))
//                .build();
//
//        GoogleIdToken idToken = verifier.verify(idTokenString);
//        if (idToken != null) {
//            GoogleIdToken.Payload payload = idToken.getPayload();
//
//            // Print user identifier
//            String userId = payload.getSubject();
//            System.out.println("User ID: " + userId);
//
//            // Get profile information from payload
//            String email = payload.getEmail();
//            boolean emailVerified = Boolean.valueOf(payload.getEmailVerified());
//            String name = (String) payload.get("name");
//            String pictureUrl = (String) payload.get("picture");
//            String locale = (String) payload.get("locale");
//            String familyName = (String) payload.get("family_name");
//            String givenName = (String) payload.get("given_name");
//
//            // Use or store profile information
//            // ...
//
//            log.info("email: " + email +
//                    "\nis email verified: " + emailVerified +
//                    "\nfull name: " + name +
//                    "\nlocation: " + locale);
//
//        } else {
//            log.warn("Invalid ID token.");
//        }
//    }
}
