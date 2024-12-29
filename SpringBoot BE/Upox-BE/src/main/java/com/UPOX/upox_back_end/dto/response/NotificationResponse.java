package com.UPOX.upox_back_end.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class NotificationResponse {
    LocalDateTime dateSend; //ngày giờ gửi
    String noti_content; //nội dung
    String heading; //header
    String type; //UNREAD và READ
}
