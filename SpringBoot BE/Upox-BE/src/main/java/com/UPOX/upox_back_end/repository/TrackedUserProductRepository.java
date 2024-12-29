package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Product;
import com.UPOX.upox_back_end.entity.TrackedUserProduct;
import com.UPOX.upox_back_end.model.IdClass.TrackedUserProductID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrackedUserProductRepository extends JpaRepository<TrackedUserProduct, TrackedUserProductID> {
    List<TrackedUserProduct> findTop10ByOrderByDateBoughtDesc();

    List<TrackedUserProduct> findAllByProduct(Product product);

    @Modifying
    @Query("DELETE FROM TrackedUserProduct trackedProduct WHERE (trackedProduct.product.id = ?1) and (trackedProduct.transaction.transactionId = ?2)")
    void deleteByIds(String productId, String transactionId);

    @Modifying
    @Query("SELECT trackedProduct FROM TrackedUserProduct trackedProduct WHERE (trackedProduct.product.id = ?1) and (trackedProduct.transaction.transactionId = ?2)")
    Optional<TrackedUserProduct> findByIds(String productId, String transactionId);
}
