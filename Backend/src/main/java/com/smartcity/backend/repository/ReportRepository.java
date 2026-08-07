package com.smartcity.backend.repository;

import com.smartcity.backend.entitiy.Category;
import com.smartcity.backend.entitiy.Report;
import com.smartcity.backend.entitiy.Status;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface ReportRepository extends JpaRepository<Report, Long> {
    List<Report> findByUserIdOrderByCreatedAtDesc(Long userId);

    List<Report> findAllByOrderByCreatedAtDesc();

    long countByStatus(Status status);

    @Query("""
        SELECT r.category, COUNT(r)
        FROM Report r
        GROUP BY r.category
    """)
    List<Object[]> countReportsByCategory();



    @Query("""
        SELECT r.status, COUNT(r)
        FROM Report r
        GROUP BY r.status
    """)
    List<Object[]> countReportsByStatus();

}
