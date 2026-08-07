package com.smartcity.backend.controller;

import com.smartcity.backend.dto.Report.ReportStatisticsResponse;
import com.smartcity.backend.dto.Report.UpdateStatusRequest;
import com.smartcity.backend.entitiy.Report;
import com.smartcity.backend.service.Report.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/reports")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminReportController {


    private final ReportService reportService;

    @GetMapping
    public ResponseEntity<List<Report>> getAllReports(){
        return ResponseEntity.ok(
                reportService.getAllReports()
        );

    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Report> updateStatus(
            @PathVariable Long id,
            @RequestBody UpdateStatusRequest request


    ){
        Report updatedReport =
                reportService.updateStatus(
                        id,
                        request.getStatus()
                );

        return ResponseEntity.ok(updatedReport);
    }


    @GetMapping("/statistics")
    public ResponseEntity<ReportStatisticsResponse> statistics(){


        return ResponseEntity.ok(
                reportService.getStatistics()
        );

    }


}
