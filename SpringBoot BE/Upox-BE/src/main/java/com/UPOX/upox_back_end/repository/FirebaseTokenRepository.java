package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Expense;
import com.UPOX.upox_back_end.entity.FirebaseToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FirebaseTokenRepository extends JpaRepository<FirebaseToken, String> {
    FirebaseToken findByToken(String token);
}
