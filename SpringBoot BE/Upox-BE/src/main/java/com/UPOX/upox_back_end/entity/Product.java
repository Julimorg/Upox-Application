package com.UPOX.upox_back_end.entity;


import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.validator.constraints.UniqueElements;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id")
    String id;

    //Attribute
//    @UniqueElements
    @Column(name = "product_name")
    String productName;

    String defCost; //JSON
    String defVolume; //JSON
    String defExpiryDate;
    String defPreserveWay;
    String segment;
    double avgUsageAmount;
    String imagePath;

    //Mới thêm
    String defOpenedExpiredDate; //8 tiếng (thời gian + đơn vị)
    String volumeUnit;
    //Foreign Key

    //Category
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    Category category;

    //One to Many với Tracked User Product
    @OneToMany(mappedBy = "product",cascade = CascadeType.ALL, orphanRemoval = true)
    List<TrackedUserProduct> trackedUserProducts;

    public void addTrackedUserProduct(TrackedUserProduct trackedUserProduct){
        if(trackedUserProducts == null){
            trackedUserProducts = new ArrayList<>();
        }
        trackedUserProducts.add(trackedUserProduct);
        trackedUserProduct.setProduct(this);
    }

}
