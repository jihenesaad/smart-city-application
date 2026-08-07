import 'package:flutter/material.dart';

import '../../data/models/report.dart';
import '../../data/models/status.dart';


class ReportCard extends StatelessWidget {

  final Report report;


  const ReportCard({
    super.key,
    required this.report,
  });



  Color _getStatusColor(Status status){

    switch(status){

      case Status.PENDING:
        return Colors.orange;

      case Status.IN_PROGRESS:
        return Colors.blue;

      case Status.RESOLVED:
        return Colors.green;

      case Status.REJECTED:
        return Colors.red;

    }

  }



  IconData _getCategoryIcon(){

    switch(report.category.name){

      case "ROAD":
        return Icons.directions_car;

      case "LIGHT":
        return Icons.lightbulb_outline;

      case "WASTE":
        return Icons.delete_outline;

      case "WATER":
        return Icons.water_drop_outlined;

      default:
        return Icons.report_problem_outlined;
    }

  }



  @override
  Widget build(BuildContext context) {


    print("IMAGE URL = ${report.imageUrl}");


    String? imageUrl;


    if(report.imageUrl != null &&
        report.imageUrl!.isNotEmpty){

      imageUrl =
          "http://10.0.2.2:8080${report.imageUrl}";

    }



    return Container(

      margin:
      const EdgeInsets.only(bottom:16),


      padding:
      const EdgeInsets.all(16),


      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(18),


        boxShadow: [

          BoxShadow(

            color:
            Colors.black.withOpacity(0.05),

            blurRadius:10,

            offset:
            const Offset(0,5),

          )

        ],

      ),



      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,


        children: [



          // IMAGE

          if(imageUrl != null)

            ClipRRect(

              borderRadius:
              BorderRadius.circular(15),


              child: Image.network(

                imageUrl,


                height:180,

                width:
                double.infinity,


                fit:
                BoxFit.cover,


                errorBuilder:
                    (context,error,stackTrace){


                  print(
                      "IMAGE ERROR : $error"
                  );


                  return Container(

                    height:180,

                    color:
                    Colors.grey.shade200,


                    child:
                    const Center(

                      child:
                      Icon(
                        Icons.broken_image,
                        size:40,
                      ),

                    ),

                  );


                },

              ),

            ),



          if(imageUrl != null)

            const SizedBox(height:15),




          Row(

            children: [


              Container(

                padding:
                const EdgeInsets.all(12),


                decoration: BoxDecoration(

                  color:
                  const Color(0xFF6366F1)
                      .withOpacity(0.1),


                  borderRadius:
                  BorderRadius.circular(12),

                ),


                child: Icon(

                  _getCategoryIcon(),

                  color:
                  const Color(0xFF6366F1),

                ),

              ),



              const SizedBox(width:15),



              Expanded(

                child: Text(

                  report.title,

                  style:
                  const TextStyle(

                    fontSize:18,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),

              )

            ],

          ),




          const SizedBox(height:15),




          Text(

            report.description,

            maxLines:2,

            overflow:
            TextOverflow.ellipsis,


            style:
            const TextStyle(

              color:Colors.grey,

              fontSize:14,

            ),

          ),




          const SizedBox(height:15),




          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,


            children: [



              Text(

                report.category.name,

                style:
                const TextStyle(

                  fontWeight:
                  FontWeight.w600,

                  color:
                  Color(0xFF6366F1),

                ),

              ),




              Container(

                padding:
                const EdgeInsets.symmetric(

                  horizontal:12,

                  vertical:6,

                ),


                decoration: BoxDecoration(

                  color:
                  _getStatusColor(report.status)
                      .withOpacity(0.15),


                  borderRadius:
                  BorderRadius.circular(20),

                ),



                child: Text(

                  report.status.name,


                  style:
                  TextStyle(

                    color:
                    _getStatusColor(
                        report.status
                    ),


                    fontWeight:
                    FontWeight.bold,


                    fontSize:12,

                  ),

                ),

              )


            ],

          )


        ],

      ),

    );

  }

}