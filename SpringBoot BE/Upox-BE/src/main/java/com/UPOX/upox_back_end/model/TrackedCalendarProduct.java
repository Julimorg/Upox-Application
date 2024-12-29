package com.UPOX.upox_back_end.model;


import com.UPOX.upox_back_end.dto.response.TrackedUserProductResponse;
import com.UPOX.upox_back_end.entity.TrackedUserProduct;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrackedCalendarProduct {
    TrackedUserProductResponse trackedUserProduct; //Thông tin product --> Set event ở trên lịch (calendar detail)
    LocalDate dateDisplay; //Ngày hiển thị, thay đổi trạng thái của cái ngày, bằng cách đếm bao nhiêu sản phẩm trùng ngày nhau
    String statusDisplay;

    //1 - 3 products trùng ngày: Màu xanh
    //4 - 7 products trùng ngày: Màu đỏ
    //8 - 10 products trùng ngày: Màu tím
    //10 trở lên trùng ngày: Màu đen

}
