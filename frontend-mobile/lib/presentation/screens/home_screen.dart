import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/report_controller.dart';
import '../widgets/app_drawer.dart';
import '../widgets/report_card.dart';



class HomeScreen extends ConsumerStatefulWidget {


  const HomeScreen({
    super.key,
  });



  @override
  ConsumerState<HomeScreen> createState()
      => _HomeScreenState();

}





class _HomeScreenState
    extends ConsumerState<HomeScreen>{



  @override
  void initState(){

    super.initState();


    Future.microtask((){

      ref
      .read(reportControllerProvider.notifier)
      .loadReports();

    });

  }




  @override
  Widget build(BuildContext context){



    final state =
        ref.watch(reportControllerProvider);



    return Scaffold(


      backgroundColor:
        const Color(0xFFF8FAFF),



      drawer:
        const AppDrawer(),




      appBar:
        AppBar(


          title:
            const Text(
              "My Reports",
              style:
              TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),


          backgroundColor:
            Colors.transparent,


          elevation:0,


          foregroundColor:
            const Color(0xFF1F2937),


        ),




      body:



      Padding(

        padding:
          const EdgeInsets.all(20),


        child:


        state.isLoading


        ?

        const Center(
          child:
          CircularProgressIndicator(),
        )



        :


        state.errorMessage != null


        ?

        Center(

          child:
          Text(
            state.errorMessage!,
            style:
            const TextStyle(
              color:Colors.red,
            ),
          ),

        )



        :


        state.reports.isEmpty


        ?

        const Center(

          child:
          Text(
            "No reports yet",
            style:
            TextStyle(
              color:Colors.grey,
              fontSize:16,
            ),
          ),

        )



        :


        ListView.builder(

          itemCount:
            state.reports.length,


          itemBuilder:
          (context,index){


            return ReportCard(

              report:
                state.reports[index],

            );


          },


        ),


      ),


    );


  }


}