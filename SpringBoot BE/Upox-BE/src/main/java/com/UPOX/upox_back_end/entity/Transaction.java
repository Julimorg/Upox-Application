package com.UPOX.upox_back_end.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

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
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String transactionId;

    //Attribute
    LocalDateTime dateTransaction;

    //Foreign key
    //One to Many với Tracked User Product
    @OneToMany(mappedBy = "transaction",cascade = CascadeType.ALL, orphanRemoval = true)
    List<TrackedUserProduct> trackedUserProducts;


    //Connect với expense
    @ManyToOne
    @JoinColumn(name = "expense_id")
    Expense expense;

    public void addTrackedUserProduct(TrackedUserProduct trackedUserProduct){
        if(trackedUserProducts == null){
            trackedUserProducts = new ArrayList<>();
        }
        trackedUserProducts.add(trackedUserProduct);
        trackedUserProduct.setTransaction(this);
    }
}
