import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/category.dart';
import '../../data/repositories/report_repository.dart';


class CreateReportState {


  final bool analyzing;

  final bool aiCompleted;


  final String title;

  final String description;


  final Category? category;


  final File? image;


  final double? latitude;

  final double? longitude;


  final String? address;



  CreateReportState({

    this.analyzing = false,

    this.aiCompleted = false,

    this.title = "",

    this.description = "",

    this.category,

    this.image,

    this.latitude,

    this.longitude,

    this.address,

  });



  CreateReportState copyWith({


    bool? analyzing,

    bool? aiCompleted,

    String? title,

    String? description,

    Category? category,

    File? image,

    double? latitude,

    double? longitude,

    String? address,


    bool clearCategory=false,



  }){


    return CreateReportState(


      analyzing:
      analyzing ?? this.analyzing,


      aiCompleted:
      aiCompleted ?? this.aiCompleted,


      title:
      title ?? this.title,


      description:
      description ?? this.description,



      category:

      clearCategory

      ?

      null

      :

      category ?? this.category,



      image:
      image ?? this.image,


      latitude:
      latitude ?? this.latitude,


      longitude:
      longitude ?? this.longitude,


      address:
      address ?? this.address,


    );

  }


}





// ================= CONTROLLER =================


class CreateReportController
    extends StateNotifier<CreateReportState> {



  final ReportRepository repository;



  CreateReportController(this.repository)
      : super(CreateReportState());


  Future<void> analyzeReport() async {

  if (state.analyzing) {
    return;
  }


  if (
    state.title.trim().isEmpty &&
    state.description.trim().isEmpty &&
    state.image == null
  ) {
    return;
  }



  // sauvegarder les données envoyées à l'IA
  final currentTitle = state.title;
  final currentDescription = state.description;
  final currentImage = state.image;



  state = state.copyWith(
    analyzing: true,
    aiCompleted: false,
  );



  try {


    final result =
    await repository.analyzeReport(

      image: currentImage,

      title: currentTitle,

      description: currentDescription,

    );

    print("AI TITLE : ${result.title}");
    print("AI DESCRIPTION : ${result.description}");
    print("AI CATEGORY : ${result.category}");



    state = state.copyWith(

      analyzing:false,


      title:
      result.title.isNotEmpty
          ? result.title
          : currentTitle,


      description:
      result.description.isNotEmpty
          ? result.description
          : currentDescription,


      category:
      result.category,


      aiCompleted:true,

    );


  }


  catch(e){


    state = state.copyWith(

      analyzing:false,

    );


    rethrow;

  }

}



  Future<void> analyzeImage(File image) async {


  state = state.copyWith(

    analyzing:true,

    image:image,

    title:"",

    description:"",

    clearCategory:true,

  );


  try {


    final result =
        await repository.analyzeReport(
        image: image,
      );



    print("TITLE = ${result.title}");
    print("DESCRIPTION = ${result.description}");
    print("CATEGORY = ${result.category}");



    state = state.copyWith(


      analyzing:false,


      title:
          result.title,


      description:
          result.description,


      category:
          result.category,


    );


  }


  catch(e){


    state = state.copyWith(

      analyzing:false,

    );


    rethrow;


  }


}

 void setTitle(String value){

  state = state.copyWith(

    title: value,

    clearCategory: true,

    aiCompleted: false,

  );

}


void setDescription(String value){

  state = state.copyWith(

    description: value,

    clearCategory: true,

    aiCompleted: false,

  );

}



void setAddress(String value) {

  state = state.copyWith(

    address: value,

  );

}


  void setLocation(

  double latitude,

  double longitude,

  String address,

  ){

  state =
  state.copyWith(

  latitude:latitude,

  longitude:longitude,

  address:address,

  );

  }






  void setCategory(Category value){


    state = state.copyWith(

      category:value,

    );


  }

  void setImage(File image){


state =
state.copyWith(

image:image,

clearCategory:true,

aiCompleted:false,

);


}







 Future<void> createReport() async {


  print("========== CREATE REPORT ==========");

  print("TITLE : ${state.title}");
  print("DESCRIPTION : ${state.description}");
  print("CATEGORY : ${state.category}");
  print("LATITUDE : ${state.latitude}");
  print("LONGITUDE : ${state.longitude}");
  print("ADDRESS : ${state.address}");
  print("IMAGE : ${state.image?.path}");



  if(state.address == null ||
   state.address!.trim().isEmpty){

 throw Exception(
   "Address is required"
 );

}


  if(state.category == null){

    print("ERROR : Category missing");

    throw Exception(
      "Category is required"
    );

  }



  try {


    await repository.createReport(

      title:
      state.title,

      description:
      state.description,

      category:
      state.category!,

      latitude:
      state.latitude!,

      longitude:
      state.longitude!,


      address:
      state.address ?? "",


      image:
      state.image,

    );


    print("REPORT CREATED SUCCESSFULLY");


  }


  catch(e, stack){


    print("CREATE REPORT ERROR : $e");

    print(stack);

    rethrow;

  }


}


}






// ================= PROVIDER =================


final createReportControllerProvider =


StateNotifierProvider<
    CreateReportController,
    CreateReportState
>(


(ref){


  return CreateReportController(

    ReportRepository(),

  );


});