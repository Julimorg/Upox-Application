package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    boolean existsByUsername(String userName); //Viết Query bằng tên hàm
    boolean existsByEmail(String email);
    Optional<User> findByUsername(String userName);

//    List<User> findTopByOrderByFirstnameAsc(); //TOP //ORDER BY
//    List<User> findByFirstnameIsContaining(String containInFirstName); //LIKE % %
}
