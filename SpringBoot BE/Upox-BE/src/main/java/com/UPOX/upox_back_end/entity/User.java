package com.UPOX.upox_back_end.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.validator.constraints.UniqueElements;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;


@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID) //Id generate không trùng lặp
    String id;
    String username;
    String password; //password phải được mã hoá
    String firstName;
    String lastName;
    LocalDate dob;
    String email;
    int gender; //1: Male; 2: Female
    String city = "";
    String phoneNum;

    //Vừa thêm
    boolean activated;
    boolean googleLogin;

    //Nếu lỗi hãy xoá dòng này
    @ElementCollection
    Set<String> roles;


    //Foreign Key
    //One to Many với Notification
    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    List<Notification> notifications;

    //One to Many với Expense
    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    List<Expense> expenses;

    //Xoá
    //One to Many với Tracked User Product
//    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
//    List<TrackedUserProduct> trackedUserProducts;

    //One to Many với User Achievements
    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    List<UserAchievement> userAchievements;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    List<FirebaseToken> firebaseTokens;

    @OneToMany(mappedBy = "user",cascade = CascadeType.ALL, orphanRemoval = true)
    List<GoogleToken> googleTokens;


    //Xoá
//    public void addTrackedUserProduct(TrackedUserProduct trackedUserProduct){
//        if(trackedUserProducts == null){
//            trackedUserProducts = new ArrayList<>();
//        }
//        trackedUserProducts.add(trackedUserProduct);
//        trackedUserProduct.setUser(this);
//    }
}
