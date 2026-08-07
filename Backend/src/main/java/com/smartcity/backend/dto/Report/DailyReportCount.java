package com.smartcity.backend.dto.Report;


import lombok.AllArgsConstructor;
import lombok.Data;


@Data
@AllArgsConstructor
public class DailyReportCount {


    private String date;


    private Long count;

}
