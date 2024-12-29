package com.UPOX.upox_back_end.entity;


import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;

//Tạo table chứa FCM token để quản lý
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity
public class FirebaseToken {
    //primary key
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String tokenId;

    //foreign key
    @ManyToOne(fetch = FetchType.LAZY)
    User user;

    //normal attribute
    String token;
    LocalDateTime dateIssued;
}
