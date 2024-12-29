package com.UPOX.upox_back_end.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.validator.constraints.UniqueElements;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class Achievement {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String achievementId;

    //Attribute
    String achievementName;
    String achievementType;
    int level;
    int limitToUpgrade;

    //Foreign key
    //One to Many với User Achievements
    @OneToMany(mappedBy = "achievement",cascade = CascadeType.ALL, orphanRemoval = true)
    List<UserAchievement> userAchievements;
}
