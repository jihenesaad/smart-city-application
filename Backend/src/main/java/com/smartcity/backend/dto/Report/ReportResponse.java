package com.smartcity.backend.dto.Report;

import com.smartcity.backend.entitiy.Category;
import com.smartcity.backend.entitiy.Status;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ReportResponse {

    private Long id;

    private String title;

    private String description;

    private Category category;

    private String imageUrl;

    private String address;

    private Double latitude;

    private Double longitude;

    private Status status;

    private LocalDateTime createdAt;
}