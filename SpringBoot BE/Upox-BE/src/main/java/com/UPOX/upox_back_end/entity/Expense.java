package com.UPOX.upox_back_end.entity;


import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Entity //Tạo một bản sao với database (Entity = thực thể/bảng)
public class Expense {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    String expenseId;

    //Attribute
    long expenseLimit;
    long totMoneySpent;
    LocalDateTime dateUpdateLimit;

    //Foreign Key
    //Many to One với User
    @ManyToOne(fetch = FetchType.LAZY)
    User user;

    //Connect với Transaction
    @OneToMany(mappedBy = "expense",cascade = CascadeType.ALL, orphanRemoval = true)
    List<Transaction> transactions;
}
