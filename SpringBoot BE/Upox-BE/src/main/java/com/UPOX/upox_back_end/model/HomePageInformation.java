package com.UPOX.upox_back_end.model;

import com.UPOX.upox_back_end.dto.response.NotificationResponse;
import com.UPOX.upox_back_end.entity.Notification;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class HomePageInformation {
    List<NotificationResponse> notifications; //loop (notification là unread)
    List<WarningCategory> warningCategories;
}
