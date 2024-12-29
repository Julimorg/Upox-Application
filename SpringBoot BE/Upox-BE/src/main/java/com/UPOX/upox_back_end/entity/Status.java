package com.UPOX.upox_back_end.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.validator.constraints.UniqueElements;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class Status {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String statusProductId;

    //Attribute
    String statusProductName;
    String statusProductType;

    //Foreign key
    //One to Many với Tracked User Product
    @OneToMany(mappedBy = "status",cascade = CascadeType.ALL, orphanRemoval = true)
    List<TrackedUserProduct> trackedUserProducts;

    public void addTrackedUserProduct(TrackedUserProduct trackedUserProduct){
        if(trackedUserProducts == null){
            trackedUserProducts = new ArrayList<>();
        }
        trackedUserProducts.add(trackedUserProduct);
        trackedUserProduct.setStatus(this);
    }
}
