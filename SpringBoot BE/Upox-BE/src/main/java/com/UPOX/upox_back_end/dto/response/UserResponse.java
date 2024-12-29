package com.UPOX.upox_back_end.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.Set;


@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponse {
     String id;
     String username;
//     String password; //password phải được mã hoá
     String firstname;
     String lastname;
     LocalDate dob;
     String email;
     int gender; //1: Male; 2: Female
     String city;
     String phoneNum;
     Set<String> roles;

     //Vừa thêm
     boolean activated;
     boolean googleLogin;
}
