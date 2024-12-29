package com.UPOX.upox_back_end.configuration;


import com.UPOX.upox_back_end.dto.request.IntrospectRequest;
import com.UPOX.upox_back_end.exception.ErrorCode;
import com.UPOX.upox_back_end.service.AuthenticateService;
import com.nimbusds.jose.JOSEException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.stereotype.Component;

import javax.crypto.spec.SecretKeySpec;
import java.text.ParseException;
import java.util.Objects;


@Component
@Slf4j
public class CustomJwtDecoder implements JwtDecoder {

    @Value("${jwt.secret.key}")
    private String SECRET;

    @Autowired
    private AuthenticateService authenticationService;

    private NimbusJwtDecoder nimbusJwtDecoder = null;

    @Override
    public Jwt decode(String token) throws JwtException {

        //String token = <abc> - special gg token


        //Xét xem token còn valid không
        try {
            var response = authenticationService.introspect(
                    IntrospectRequest.builder().token(token).build());

            if (!response.isValid()) {

                throw new JwtException(ErrorCode.USER_NOT_AUTHENTICATED.getMessage()); //Không valid
            }
        } catch (JOSEException | ParseException e) {
            throw new JwtException(e.getMessage()); //Không valid
        }

        //token valid
        if (Objects.isNull(nimbusJwtDecoder)) {
            SecretKeySpec secretKeySpec = new SecretKeySpec(SECRET.getBytes(), "HS512");
            nimbusJwtDecoder = NimbusJwtDecoder.withSecretKey(secretKeySpec)
                    .macAlgorithm(MacAlgorithm.HS512)
                    .build();
        }

        //Return token cho Spring Security decoder
        return nimbusJwtDecoder.decode(token);
    }
}
