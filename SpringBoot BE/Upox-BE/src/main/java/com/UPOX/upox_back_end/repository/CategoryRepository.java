package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Category;
import com.UPOX.upox_back_end.entity.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, String> {
    Optional<Category> findByCategoryName(String categoryName);
}
