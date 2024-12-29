package com.UPOX.upox_back_end.dto.request;


import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Data //Cung cấp các method getter/setter, toString, equalHashCode, requiredArgsConstructor
@NoArgsConstructor
@AllArgsConstructor
@Builder //Tạo ra 1 builder class cho một DTO
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrackedUserProductRequest { //1 List các sản phẩm cần thêm

    String productName;
    String dateBought;
    String expiryDate;
    int peopleUse;
    int volume;
    int cost;
    String frequency;
    String wayPreserve;


    //Opened
    boolean opened;
    String dateOpen;


    //Vừa thêm
    int numProductOpened;
    int quantity;
    String wayPayment;
}
