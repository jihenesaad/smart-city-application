package com.smartcity.backend.dto.Report;

import com.smartcity.backend.entitiy.Category;

public record ReportAnalysisResponse(
        String title,
        String description,
        Category category
) {}
