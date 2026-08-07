package com.smartcity.backend.controller;

import com.smartcity.backend.dto.Report.ClassificationResult;
import com.smartcity.backend.dto.Report.CreateReportRequest;
import com.smartcity.backend.dto.Report.ReportAnalysisResponse;
import com.smartcity.backend.dto.Report.ReportResponse;
import com.smartcity.backend.entitiy.Category;
import com.smartcity.backend.entitiy.Report;
import com.smartcity.backend.entitiy.User;
import com.smartcity.backend.exception.AiProcessingException;
import com.smartcity.backend.repository.UserRepository;
import com.smartcity.backend.service.Report.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;
    private final UserRepository userRepository;



    @PostMapping(
            value="/analyze",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public ResponseEntity<?> analyzeReport(


            @RequestParam(required = false)
            MultipartFile image,


            @RequestParam(required = false)
            String title,


            @RequestParam(required = false)
            String description


    ){
        ReportAnalysisResponse result =

                reportService.analyzeReport(

                        image,

                        title,

                        description

                );


        return ResponseEntity.ok(result);

    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<Report> createReport(

            @RequestParam String title,

            @RequestParam(required = false) String description,

            @RequestParam Category category,

            @RequestParam(required = false) Double latitude,

            @RequestParam(required = false) Double longitude,

            @RequestParam String address,

            @RequestParam(required = false) MultipartFile image,

            @AuthenticationPrincipal User currentUser

    ){

        CreateReportRequest request =
                new CreateReportRequest(
                        title,
                        description,
                        category,
                        address,
                        longitude,
                        latitude,
                        image
                );


        Report created =
                reportService.createReport(
                        request,
                        currentUser
                );


        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(created);

    }

    @GetMapping("/getReportsByUser")
    public ResponseEntity<List<ReportResponse>> getMyReports(
            @AuthenticationPrincipal UserDetails userDetails
    )
    {
        System.out.println("========== CONTROLLER ==========");
        System.out.println("USER DETAILS : " + userDetails);
        System.out.println("USERNAME : " + userDetails.getUsername());


        User currentUser =
                userRepository.findByEmail(userDetails.getUsername())
                        .orElseThrow(
                                () -> new RuntimeException("User not found")
                        );


        List<Report> reports =
                reportService.getReportsByUser(currentUser);


        List<ReportResponse> responses =
                reports.stream()
                        .map(report -> ReportResponse.builder()
                                .id(report.getId())
                                .title(report.getTitle())
                                .description(report.getDescription())
                                .category(report.getCategory())
                                .imageUrl(report.getImageUrl())
                                .latitude(report.getLatitude())
                                .longitude(report.getLongitude())
                                .status(report.getStatus())
                                .createdAt(report.getCreatedAt())
                                .build()
                        )
                        .toList();


        return ResponseEntity.ok(responses);
    }

    @ExceptionHandler(AiProcessingException.class)
    public ResponseEntity<String> handleAiFailure(AiProcessingException ex) {

        return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
                .body("Ai processing of the report failed. Please try again. (" + ex.getMessage() + ")");
    }
}
