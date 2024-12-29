package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.FirebaseToken;
import com.UPOX.upox_back_end.entity.GoogleToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GoogleTokenRepository extends JpaRepository<GoogleToken, String> {
    GoogleToken findByToken(String token);
}
