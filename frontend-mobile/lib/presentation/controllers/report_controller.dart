import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/report.dart';
import '../../data/repositories/report_repository.dart';



final reportControllerProvider =
StateNotifierProvider<
    ReportController,
    ReportState
>((ref){

  return ReportController(
      ReportRepository()
  );

});



class ReportState {


  final bool isLoading;


  final List<Report> reports;


  final String? errorMessage;



  ReportState({

    this.isLoading = false,

    this.reports = const [],

    this.errorMessage,

  });



  ReportState copyWith({

    bool? isLoading,

    List<Report>? reports,

    String? errorMessage,


  }){


    return ReportState(

      isLoading:
          isLoading ?? this.isLoading,


      reports:
          reports ?? this.reports,


      errorMessage:
          errorMessage,

    );


  }


}





class ReportController 
    extends StateNotifier<ReportState>{


  final ReportRepository repository;



  ReportController(this.repository)
      : super(ReportState());




  Future<void> loadReports() async {


    state = state.copyWith(

      isLoading: true,

      errorMessage: null,

    );



    try{


      final reports =
          await repository.getReportsByUser();



      state = state.copyWith(

        isLoading: false,

        reports: reports,

      );



    }
    catch(e){



      state = state.copyWith(

        isLoading: false,

        errorMessage:
          e.toString()
          .replaceAll(
             "Exception:",
             ""
          ),

      );


    }


  }



  void clearError(){

    state =
        state.copyWith(
          errorMessage:null
        );

  }


}