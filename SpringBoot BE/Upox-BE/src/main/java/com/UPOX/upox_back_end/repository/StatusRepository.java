package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Status;
import com.UPOX.upox_back_end.entity.TrackedUserProduct;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StatusRepository extends JpaRepository<Status, String> {
    Optional<Status> findByStatusProductName(String statusName);
}
