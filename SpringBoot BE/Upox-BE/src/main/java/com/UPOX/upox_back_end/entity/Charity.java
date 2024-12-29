package com.UPOX.upox_back_end.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class Charity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String charityId;

    //Attribute
    String placeToCharity;
    String charityStatus; //CONFIRMED, TOOK UP, RECEIVED
    boolean isEditable; //withing 2 days

    //Foreign key
    //One to Many với Tracked User Product
    @OneToMany(mappedBy = "charity",cascade = CascadeType.ALL, orphanRemoval = true)
    List<TrackedUserProduct> trackedUserProducts;

}
