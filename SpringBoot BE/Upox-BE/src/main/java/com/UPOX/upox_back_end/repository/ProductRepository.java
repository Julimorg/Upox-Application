package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Product;
import com.UPOX.upox_back_end.entity.TrackedUserProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {
//    Optional<Product> findByProductNameLike(String productNameLike);
//
//    Optional<Product> findByProductId(String productId);

    Optional<Product> findByProductName(String productName);
}
