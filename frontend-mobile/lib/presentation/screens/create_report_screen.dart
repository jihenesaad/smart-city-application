import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/category.dart';
import '../controllers/create_report_controller.dart';

import 'location_picker_screen.dart';
import 'dart:async';


class CreateReportScreen extends ConsumerStatefulWidget {

  const CreateReportScreen({
    super.key,
  });


  @override
  ConsumerState<CreateReportScreen> createState() =>
      _CreateReportScreenState();

}



class _CreateReportScreenState
    extends ConsumerState<CreateReportScreen> {


  late TextEditingController titleController;

  late TextEditingController descriptionController;

  late TextEditingController addressController;

  Timer? _debounce;



  @override
  void initState() {

    super.initState();


    titleController =
        TextEditingController();


    descriptionController =
        TextEditingController();

    addressController = 
        TextEditingController();

  }



  @override
  void dispose() {

    _debounce?.cancel();

    titleController.dispose();

    descriptionController.dispose();

    addressController.dispose();

    super.dispose();

  }


void updateControllersFromAI(CreateReportState state) {

  if(titleController.text != state.title){

    titleController.text = state.title;

    titleController.selection =
        TextSelection.fromPosition(
          TextPosition(
            offset: titleController.text.length,
          ),
        );
  }



  if(descriptionController.text != state.description){

    descriptionController.text = state.description;

    descriptionController.selection =
        TextSelection.fromPosition(
          TextPosition(
            offset: descriptionController.text.length,
          ),
        );
  }

}

  void onTitleChanged(
    String value,
    CreateReportController controller
) {


controller.setTitle(value);



_debounce?.cancel();



_debounce = Timer(

  const Duration(seconds: 2),

  () async {


  final state =
  ref.read(createReportControllerProvider);



  // Pas d'analyse si tout est vide
  if(
  state.title.isEmpty &&
  state.description.isEmpty &&
  state.image == null
  ){

  return;

  }



  // lancer IA seulement sans image
  if(state.image == null){


  await controller.analyzeReport();


  }


  });


  }


  Future<void> pickImage(ImageSource source) async {

  final picker = ImagePicker();

  final picked =
  await picker.pickImage(
  source: source
  );


  if(picked != null){

  final image = File(picked.path);

  final controller =
      ref.read(createReportControllerProvider.notifier);


  await controller.analyzeImage(image);


  final state =
      ref.read(createReportControllerProvider);


  titleController.text = state.title;
  descriptionController.text = state.description;

}

  }
  

@override
Widget build(BuildContext context) {


  final state =
      ref.watch(createReportControllerProvider);

  
  WidgetsBinding.instance.addPostFrameCallback((_) {

    updateControllersFromAI(state);

  });


  final controller =
      ref.read(createReportControllerProvider.notifier);



  return Scaffold(

    appBar: AppBar(
      title: const Text("Create Report"),
    ),



    body: SingleChildScrollView(


      padding: const EdgeInsets.all(20),


      child: Column(


        crossAxisAlignment:
            CrossAxisAlignment.start,


        children: [



          const Text(
            "Image (optional)",
            style: TextStyle(
              fontSize:18,
              fontWeight:FontWeight.bold,
            ),
          ),



          const SizedBox(height:10),




          if(state.image != null)


            ClipRRect(

              borderRadius:
              BorderRadius.circular(15),


              child: Image.file(

                state.image!,

                height:200,

                width:
                double.infinity,

                fit:
                BoxFit.cover,

              ),

            )


          else


            Container(

              height:150,

              width:
              double.infinity,


              decoration:BoxDecoration(

                color:
                Colors.grey.shade200,


                borderRadius:
                BorderRadius.circular(15),

              ),


              child:
              const Center(

                child:
                Text(
                  "No image selected",
                ),

              ),

            ),




          const SizedBox(height:15),




              Row(

                children:[


                  Expanded(

                    child:
                    ElevatedButton.icon(

                      icon:
                      const Icon(Icons.photo),


                      label:
                      const Text("Gallery"),


                      onPressed:
                      () =>
                          pickImage(
                              ImageSource.gallery
                          ),

                    ),

                  ),



                  const SizedBox(width:10),



                  Expanded(

                    child:
                    ElevatedButton.icon(

                      icon:
                      const Icon(Icons.camera_alt),


                      label:
                      const Text("Camera"),


                      onPressed:
                      () =>
                          pickImage(
                              ImageSource.camera
                          ),

                    ),

                  ),


                ],

              ),





              const SizedBox(height:25),


    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        // Loader IA sans cacher les champs
        if (state.analyzing)

          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),

                SizedBox(width: 10),

                Text(
                  "AI is analyzing...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),


        TextField(

          controller: titleController,

          decoration: const InputDecoration(

            labelText: "Title",

            border: OutlineInputBorder(),

          ),


          onChanged: (value){

            onTitleChanged(
              value,
              controller,
            );

          },


          onTapOutside: (_) async {

          final currentState =
              ref.read(createReportControllerProvider);


          if(
            currentState.image == null &&
            currentState.title.isNotEmpty
          ){

            await controller.analyzeReport();

          }

        },

        ),



        const SizedBox(height:15),



        TextField(

          controller: descriptionController,

          maxLines:4,


          decoration: const InputDecoration(

            labelText:"Description",

            border:OutlineInputBorder(),

          ),


          onChanged:(value){

          controller.setDescription(value);


          _debounce?.cancel();


          _debounce = Timer(
            const Duration(seconds:2),
            () async {


              final currentState =
              ref.read(createReportControllerProvider);



              if(currentState.image == null &&
                  (
                      currentState.title.isNotEmpty ||
                      currentState.description.isNotEmpty
                  )
              ){

                await controller.analyzeReport();

              }


            },
          );

        },

        ),



        const SizedBox(height:15),



        DropdownButtonFormField<Category>(

          key: ValueKey(state.category),


          value: state.category,


          decoration: InputDecoration(


            labelText:"Category",


            border:
            const OutlineInputBorder(),



            suffixIcon:

            state.aiCompleted

            ?

            const Icon(
              Icons.check_circle,
              color: Colors.green,
            )


            :

            const Icon(
              Icons.lock,
              color: Colors.grey,
            ),


          ),




          items:

          Category.values.map((category){


            return DropdownMenuItem(


              value: category,


              child:
              Text(category.name),


            );


          }).toList(),





          onChanged:

          state.aiCompleted

          ?

          (value){


            if(value != null){


              controller.setCategory(value);


            }


          }


          :

          null,


        ),



      ],
    ),


          const SizedBox(height:25),




          const Text(

            "Location",

            style:
            TextStyle(

              fontSize:18,

              fontWeight:
              FontWeight.bold,

            ),

          ),




          const SizedBox(height:15),






          TextField(


            controller:
            addressController,


            maxLines:2,



            decoration:
            const InputDecoration(

              labelText:
              "Address",


              hintText:
              "Enter address or choose on map",


              border:
              OutlineInputBorder(),


              prefixIcon:
              Icon(
                  Icons.location_on
              ),

            ),



            onChanged:
            controller.setAddress,


          ),






          const SizedBox(height:15),






          SizedBox(

            width:
            double.infinity,


            child:
            ElevatedButton.icon(


              icon:
              const Icon(
                  Icons.map
              ),



              label:
              const Text(
                "Choose location",
              ),




              onPressed:
              () async {



                final result =
                await Navigator.push(


                  context,


                  MaterialPageRoute(

                    builder:
                        (_) =>
                    const LocationPickerScreen(),

                  ),

                );



                if(result != null){



                  controller.setLocation(

                    result["latitude"],

                    result["longitude"],

                    result["address"],

                  );



                  addressController.text =
                      result["address"];


                }



              },


            ),


          ),






          const SizedBox(height:35),






          SizedBox(

            width:
            double.infinity,


            height:
            50,


            child:
            ElevatedButton(



              child:
              const Text(

                "Submit Report",

                style:
                TextStyle(
                  fontSize:16,
                ),

              ),




              onPressed:
              () async {



                try{


                  await controller.createReport();



                  if(context.mounted){


                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content:
                        Text(
                            "Report created successfully"
                        ),

                      ),

                    );



                    Navigator.pop(
                        context,
                        true
                    );


                  }



                }

                catch(e){


                  if(context.mounted){


                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      SnackBar(

                        content:
                        Text(
                            e.toString()
                        ),

                      ),

                    );


                  }


                }



              },



            ),


          ),



          const SizedBox(height:20),



        ],


      ),

    ),


  );


}

    }