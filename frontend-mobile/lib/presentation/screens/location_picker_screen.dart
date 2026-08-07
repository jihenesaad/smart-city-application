import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';



class LocationPickerScreen extends StatefulWidget {


  const LocationPickerScreen({
    super.key,
  });



  @override
  State<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();

}






class _LocationPickerScreenState
    extends State<LocationPickerScreen> {



  final MapController mapController =
      MapController();



  final TextEditingController searchController =
      TextEditingController();




  LatLng selectedPosition =
      const LatLng(
        36.8065,
        10.1815,
      );



  String selectedAddress =
      "Select location";






  Future<String> reverseGeocode(

      double lat,

      double lon

      ) async {


    try {


      final url = Uri.parse(

        "https://nominatim.openstreetmap.org/reverse?"
            "format=json&lat=$lat&lon=$lon&accept-language=fr",

      );



      final response =
          await http.get(

            url,

            headers: {

              "User-Agent":
              "SmartCityApp"

            },

          );



      if(response.statusCode == 200){


        final data =
        jsonDecode(response.body);



        return data["display_name"] ??
            "Unknown position";


      }


    }
    catch(e){

      print(
        "REVERSE ERROR : $e",
      );

    }



    return "Unknown position";


  }







  Future<void> updateMarker(
      LatLng position
      ) async {


    setState(() {


      selectedPosition =
          position;


      selectedAddress =
          "Loading address...";


    });



    mapController.move(
      position,
      16,
    );



    final address =
        await reverseGeocode(

          position.latitude,

          position.longitude,

        );



    setState(() {


      selectedAddress =
          address;


    });


  }








  Future<void> searchLocation() async {


    if(searchController.text.isEmpty)
      return;



    try {


      final url = Uri.parse(

          "https://nominatim.openstreetmap.org/search?"
              "format=json&q=${searchController.text}"
              "&accept-language=fr"

      );



      final response =
      await http.get(

        url,

        headers:{

          "User-Agent":
          "SmartCityApp"

        },

      );



      final List data =
      jsonDecode(response.body);



      if(data.isNotEmpty){


        final place =
        data.first;



        final lat =
        double.parse(
            place["lat"]
        );



        final lon =
        double.parse(
            place["lon"]
        );



        updateMarker(

          LatLng(
            lat,
            lon,
          ),

        );


      }



    }
    catch(e){

      print(
        "SEARCH ERROR : $e",
      );

    }


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        title:
        const Text(
          "Choose Location",
        ),


      ),





      body: Stack(


        children: [



          FlutterMap(


            mapController:
            mapController,



            options: MapOptions(


              initialCenter:
              selectedPosition,



              initialZoom:
              15,



              onTap:
                  (tapPosition, point){


                updateMarker(point);


              },


            ),




            children: [



              TileLayer(


                urlTemplate:

                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",



                userAgentPackageName:
                "com.example.frontend",


              ),






              MarkerLayer(


                markers:[


                  Marker(


                    point:
                    selectedPosition,



                    width:
                    50,



                    height:
                    50,



                    child:

                    const Icon(

                      Icons.location_pin,

                      color:
                      Colors.red,

                      size:
                      50,

                    ),

                  )


                ],


              ),



            ],


          ),







          // SEARCH BAR


          Positioned(


            top:20,

            left:15,

            right:15,


            child: Card(


              child: TextField(


                controller:
                searchController,



                decoration:
                InputDecoration(


                  hintText:
                  "Search address...",



                  prefixIcon:
                  const Icon(
                    Icons.search,
                  ),



                  suffixIcon:

                  IconButton(


                    icon:
                    const Icon(
                      Icons.send,
                    ),


                    onPressed:
                    searchLocation,


                  ),


                ),


              ),


            ),


          ),







          // ZOOM BUTTONS


          Positioned(


            right:15,

            bottom:220,


            child:Column(


              children:[



                FloatingActionButton.small(


                  heroTag:"zoomIn",


                  child:
                  const Icon(
                    Icons.add,
                  ),



                  onPressed:(){


                    mapController.move(

                      selectedPosition,

                      mapController.camera.zoom + 1,

                    );


                  },


                ),




                const SizedBox(height:10),





                FloatingActionButton.small(


                  heroTag:"zoomOut",


                  child:
                  const Icon(
                    Icons.remove,
                  ),



                  onPressed:(){


                    mapController.move(

                      selectedPosition,

                      mapController.camera.zoom - 1,

                    );


                  },


                ),



              ],


            ),


          ),






          // BOTTOM PANEL


          Positioned(


            bottom:0,

            left:0,

            right:0,


            child:Container(


              padding:
              const EdgeInsets.all(15),



              color:
              Colors.white,



              child:Column(


                crossAxisAlignment:
                CrossAxisAlignment.start,



                children:[



                  Text(

                    selectedAddress,

                    maxLines:2,

                    overflow:
                    TextOverflow.ellipsis,

                  ),





                  const SizedBox(height:10),






                  ElevatedButton(


                    style:
                    ElevatedButton.styleFrom(

                      minimumSize:
                      const Size(
                        double.infinity,
                        45,
                      ),

                    ),



                    onPressed:(){


                      Navigator.pop(

                        context,

                        {


                          "latitude":
                          selectedPosition.latitude,


                          "longitude":
                          selectedPosition.longitude,


                          "address":
                          selectedAddress,


                        },


                      );


                    },



                    child:
                    const Text(
                      "Confirm Location",
                    ),


                  )



                ],


              ),


            ),


          )




        ],


      ),



    );


  }


}