package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Transaction;
import com.UPOX.upox_back_end.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, String> {
}
