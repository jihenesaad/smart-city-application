import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/data/models/category.dart';
import 'package:frontend/data/models/report_analysis.dart';

import '../../core/api_client.dart';
import '../models/report.dart';


class ReportRepository {
  final Dio _dio = ApiClient.dio;

  Future<List<Report>> getReportsByUser() async {
    try {
      print(
        "COOKIE BEFORE REQUEST : ${await ApiClient.cookieJar.loadForRequest(
            Uri.parse('http://10.0.2.2:8080/api/reports/getReportsByUser')
        )}"
      );
      final response = await _dio.get("/reports/getReportsByUser");

      print("========== REPORTS ==========");
      print("STATUS : ${response.statusCode}");
      print("TYPE   : ${response.data.runtimeType}");
      print("DATA   : ${response.data}");
      print("=============================");

      final List data = response.data;

      return data
          .map((json) => Report.fromJson(json))
          .toList();

    } on DioException catch (e) {

      print("========== DIO ERROR ==========");
      print("STATUS : ${e.response?.statusCode}");
      print("TYPE   : ${e.response?.data.runtimeType}");
      print("BODY   : ${e.response?.data}");
      print("===============================");

      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message']
            : "Unable to load reports",
      );
    }
  }

 Future<ReportAnalysis> analyzeReport({

File? image,

String? title,

String? description,

}) async {


FormData formData =
FormData.fromMap({



if(image != null)

"image":
await MultipartFile.fromFile(
image.path
),



"title":
title ?? "",



"description":
description ?? "",


});



final response =
await _dio.post(

"/reports/analyze",

data:formData

);



return ReportAnalysis.fromJson(
response.data
);


}

Future<void> createReport({

required String title,

required String description,

required Category category,

required double latitude,

required double longitude,

required String address,

File? image,

}) async {



print("===== REPOSITORY CREATE REPORT =====");


print("title = $title");
print("description = $description");
print("category = $category");
print("lat = $latitude");
print("lng = $longitude");
print("address = $address");
print("image = ${image?.path}");



try {


FormData formData =
FormData.fromMap({


"title": title,


"description": description,


"category": category.name,


"latitude": latitude,


"longitude": longitude,


"address": address,


if(image != null)

"image":
await MultipartFile.fromFile(
image.path
)


});



print("FORM DATA CREATED");



final response =
await _dio.post(

"/reports",

data: formData

);



print("STATUS CODE : ${response.statusCode}");

print("RESPONSE DATA : ${response.data}");



}



on DioException catch(e){


print("========== DIO ERROR ==========");

print("STATUS : ${e.response?.statusCode}");

print("DATA : ${e.response?.data}");

print("MESSAGE : ${e.message}");



rethrow;


}


}
}