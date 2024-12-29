package com.UPOX.upox_back_end.repository;

import com.UPOX.upox_back_end.entity.Expense;
import com.UPOX.upox_back_end.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Month;
import java.time.Year;
import java.util.List;
import java.util.Optional;

@Repository
public interface ExpenseRepository extends JpaRepository<Expense, String> {
    @Query("select e from Expense e where year(e.dateUpdateLimit) = ?1 and month(e.dateUpdateLimit) = ?2 and e.user = ?3")
    Optional<Expense> findByYearAndMonthForUser(int year, int month, User user);
}
