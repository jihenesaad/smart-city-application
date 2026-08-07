package com.smartcity.backend.service.Report;

import com.smartcity.backend.dto.Report.ClassificationResult;
import com.smartcity.backend.dto.Report.CreateReportRequest;
import com.smartcity.backend.dto.Report.ReportAnalysisResponse;
import com.smartcity.backend.dto.Report.ReportStatisticsResponse;
import com.smartcity.backend.entitiy.Report;
import com.smartcity.backend.entitiy.Status;
import com.smartcity.backend.entitiy.User;
import com.smartcity.backend.exception.AiProcessingException;
import com.smartcity.backend.repository.ReportRepository;
import com.smartcity.backend.repository.UserRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportAiOrchestrator aiOrchestrator;
    private final FileStorageService fileStorageService;
    private final ReportRepository reportRepository;

    private final UserRepository userRepository;



    public ReportAnalysisResponse analyzeReport(
            MultipartFile image,
            String title,
            String description
    ) {


        try {


            byte[] imageBytes = null;

            String mimeType = null;


            if(image != null && !image.isEmpty()) {


                imageBytes =
                        image.getBytes();



                mimeType =
                        image.getContentType();


                if(mimeType == null){

                    mimeType = "image/jpeg";

                }

            }


            ClassificationResult result =
                    aiOrchestrator.process(

                            title,

                            description,

                            imageBytes,

                            mimeType

                    );



            if(result == null){


                throw new AiProcessingException(
                        "No AI result returned"
                );


            }




            return new ReportAnalysisResponse(

                    result.title(),

                    result.description(),

                    result.category()

            );


        }

        catch(Exception e){


            throw new AiProcessingException(

                    "Error during AI report analysis",

                    e

            );


        }


    }
    @Transactional
    public Report createReport(
            CreateReportRequest request,
            User currentUser
    ){


        String imageUrl = null;


        try {


            if(request.image() != null &&
                    !request.image().isEmpty()) {


                imageUrl =
                        fileStorageService.store(
                                request.image()
                        );

            }


        }
        catch(Exception e){

            throw new RuntimeException(
                    "Impossible de sauvegarder image",
                    e
            );

        }

        Report report =
                Report.builder()

                        .title(
                                request.title()
                        )

                        .description(
                                request.description()
                        )

                        .category(
                                request.category()
                        )

                        .imageUrl(
                                imageUrl
                        )

                        .address(
                                request.address()
                        )

                        .latitude(
                                request.latitude()
                        )

                        .longitude(
                                request.longitude()
                        )

                        .status(
                                Status.PENDING
                        )

                        .user(
                                currentUser
                        )

                        .build();



        return reportRepository.save(report);

    }


    @Transactional
    public List<Report> getReportsByUser(User currentUser) {


        if(currentUser == null ||
                currentUser.getId() == null){

            throw new ResponseStatusException(
                    HttpStatus.UNAUTHORIZED,
                    "Utilisateur non authentifié"
            );

        }


        return reportRepository
                .findByUserIdOrderByCreatedAtDesc(
                        currentUser.getId()
                );

    }


    public List<Report> getAllReports(){


        return reportRepository
                .findAllByOrderByCreatedAtDesc();

    }

    public Report updateStatus(
            Long reportId,
            Status newStatus
    ){


        Report report =
                reportRepository.findById(reportId)
                        .orElseThrow(
                                () -> new RuntimeException(
                                        "Report not found"
                                )
                        );



        report.setStatus(newStatus);



        return reportRepository.save(report);

    }

    public ReportStatisticsResponse getStatistics(){


        long total =
                reportRepository.count();



        long pending =
                reportRepository.countByStatus(Status.PENDING);



        long inProgress =
                reportRepository.countByStatus(Status.IN_PROGRESS);



        long resolved =
                reportRepository.countByStatus(Status.RESOLVED);



        long rejected =
                reportRepository.countByStatus(Status.REJECTED);



        Map<String,Long> reportsByCategory =
                reportRepository.countReportsByCategory()
                        .stream()
                        .collect(Collectors.toMap(

                                row -> row[0].toString(),

                                row -> ((Number) row[1]).longValue()

                        ));



        Map<String,Long> reportsByStatus =
                reportRepository.countReportsByStatus()
                        .stream()
                        .collect(Collectors.toMap(

                                row -> row[0].toString(),

                                row -> ((Number) row[1]).longValue()

                        ));



        return new ReportStatisticsResponse(

                total,

                pending,

                inProgress,

                resolved,

                rejected,

                reportsByCategory,

                reportsByStatus

        );


    }

}
