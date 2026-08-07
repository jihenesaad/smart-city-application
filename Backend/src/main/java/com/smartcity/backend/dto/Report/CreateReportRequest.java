package com.smartcity.backend.dto.Report;

import com.smartcity.backend.entitiy.Category;
import org.springframework.web.multipart.MultipartFile;

public record CreateReportRequest(

        String title,

        String description,

        Category category,

        String address,

        Double latitude,

        Double longitude,

        MultipartFile image

){}