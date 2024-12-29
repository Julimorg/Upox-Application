package com.UPOX.upox_back_end.entity;

import com.UPOX.upox_back_end.model.IdClass.UserAchievementID;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
@IdClass(UserAchievementID.class)
public class UserAchievement {

    //Foreign Key
    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    User user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    Achievement achievement;

    //Attribute
    LocalDateTime dateProgressUpdate;
    int progress;
}
