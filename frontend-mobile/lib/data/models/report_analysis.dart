


import 'package:frontend/data/models/category.dart';

class ReportAnalysis {


  final String title;

  final String description;

  final Category category;



  ReportAnalysis({

    required this.title,

    required this.description,

    required this.category,

  });



  factory ReportAnalysis.fromJson(
      Map<String,dynamic> json
      ){

    return ReportAnalysis(

      title:
      json['title'] ?? "",


      description:
      json['description'] ?? "",


      category:
      Category.fromString(
          json['category']
      ),

    );

  }

}