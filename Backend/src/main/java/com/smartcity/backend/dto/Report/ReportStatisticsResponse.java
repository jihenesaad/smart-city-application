package com.smartcity.backend.dto.Report;

import lombok.AllArgsConstructor;
import lombok.Data;


import java.util.Map;

@Data
@AllArgsConstructor
public class ReportStatisticsResponse {

    private long totalReports;

    private long pending;

    private long inProgress;

    private long resolved;

    private long rejected;

    private Map<String,Long> reportsByCategory;


    private Map<String,Long> reportsByStatus;


}
