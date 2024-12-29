package com.UPOX.upox_back_end.entity;

import com.UPOX.upox_back_end.model.IdClass.TrackedUserProductID;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.springframework.data.domain.Persistable;

import javax.annotation.Nullable;
import java.io.Serializable;
import java.time.LocalDateTime;

import static jakarta.persistence.GenerationType.AUTO;
import static jakarta.persistence.GenerationType.SEQUENCE;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
@IdClass(TrackedUserProductID.class)
public class TrackedUserProduct implements Persistable<TrackedUserProductID> {
    //Foreign Key
    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "transaction_id")
    Transaction transaction;

    //Xoá mối quan hệ
//    @Id
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "user_id")
//    User user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    Product product;



    @ManyToOne()
    @JoinColumn(name = "status_id")
    Status status;

    @ManyToOne()
    @JoinColumn(name = "charity_id")
    Charity charity;

    //Attribute
    //Unopened
    LocalDateTime dateBought;
    LocalDateTime expiryDate;
    LocalDateTime dateStatusChange;
    int peopleUse;
    int volume;
    int cost; //Tổng tiền của sản phẩm (theo thói quen của người dùng sẽ nhập giá tổng)
    //Vừa update
    String frequency; // 1/1: 1 ngày 1 lần; 1/2: 2 ngày 1 lần, 1/7: 1 tuần 1 lần; 1/30: 1 tháng 1 lần; 2/1: 2 lần 1 ngày
    String wayPreserve;


    //Opened
    boolean isOpened;
    @Column(nullable = true)
    LocalDateTime dateOpen; // latest date open a product
    @Column(nullable = true)
    int volumeLeft; //total volume left


    @Column(nullable = true)
    int numProductOpened; //total product open
    int quantity;

    //Mới thêm
    String productsInUse; //thông tin chi tiết product đã mở //JSON
    //{
    // productsInUse: [
    //     {
    //      "id":
    //      "openDateStatusChange":
    //      "dateOpen":
    //      "volumeLeft":
    //      "openExpiryDate":
    //      "openStatusId":
    //      "avgAmountUse":
    //     }
    //  ]
    // }

    @Transient
    private boolean isNew = true;

    // Constructors, getters, and setters

    @Override
    public TrackedUserProductID getId() {
        return new TrackedUserProductID(transaction, product);
    }

    @Override
    public boolean isNew() {
        return isNew;
    }


}
