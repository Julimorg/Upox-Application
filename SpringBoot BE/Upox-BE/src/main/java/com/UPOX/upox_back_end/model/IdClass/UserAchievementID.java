package com.UPOX.upox_back_end.model.IdClass;

import com.UPOX.upox_back_end.entity.Achievement;
import com.UPOX.upox_back_end.entity.User;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserAchievementID implements Serializable {
    User user;
    Achievement achievement;
}
