package com.UPOX.upox_back_end.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.Date;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class InvalidateToken {
    @Id
    String id;
    //Tạo những job chạy đình kỳ để xoá token
    Date expiredDate; //Khi mà token đến thời điểm này, sẽ tự remove token này (làm giảm việc cho db)

}
