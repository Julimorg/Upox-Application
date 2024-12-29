package com.UPOX.upox_back_end.dto.request;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class GoogleLoginRequest {
    String userId;
    String username;
    String email;
    String familyName;
    String givenName;
    String picture;
    String locale;
    boolean verified;
    String googleToken;
}
