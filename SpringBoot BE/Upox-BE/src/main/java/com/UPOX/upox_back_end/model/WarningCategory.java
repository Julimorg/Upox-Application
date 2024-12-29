package com.UPOX.upox_back_end.model;

import com.UPOX.upox_back_end.entity.Category;
import com.UPOX.upox_back_end.entity.Status;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class WarningCategory {
    String categoryName;
    String imagePath;
    String statusName;
}
