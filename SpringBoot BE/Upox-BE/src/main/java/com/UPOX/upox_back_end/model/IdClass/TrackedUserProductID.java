package com.UPOX.upox_back_end.model.IdClass;

import com.UPOX.upox_back_end.entity.Product;
import com.UPOX.upox_back_end.entity.Transaction;
import com.UPOX.upox_back_end.entity.User;
import jakarta.persistence.Embeddable;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Embeddable
public class TrackedUserProductID implements Serializable {
    Transaction transaction;
    Product product;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TrackedUserProductID that = (TrackedUserProductID) o;
        return Objects.equals(product.getId(), that.product.getId()) &&
                Objects.equals(transaction.getTransactionId(), that.transaction.getTransactionId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(product, transaction);
    }
}
