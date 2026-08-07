import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../controllers/report_controller.dart';

class AppDrawer extends ConsumerWidget  {


  const AppDrawer({
    super.key,
  });



  @override
 Widget build(BuildContext context, WidgetRef ref)  {

  final authState = ref.watch(authControllerProvider);

  final user = authState.user;


    return Drawer(

      child: Column(

        children: [


          UserAccountsDrawerHeader(

            decoration:
              const BoxDecoration(

                color:
                Color(0xFF6366F1),

              ),


            currentAccountPicture:

              const CircleAvatar(

                backgroundColor:
                  Colors.white,


                child:

                Icon(

                  Icons.person,

                  color:
                    Color(0xFF6366F1),

                  size:35,

                ),

              ),


            accountName:

              Text(
                user != null
                    ? "${user.firstName} ${user.lastName}"
                    : "Smart City User",

                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                ),
            ),


            accountEmail:

              Text(
                user?.email ?? "user@email.com",
            ),

          ),




          ListTile(

            leading:
              const Icon(Icons.home),


            title:
              const Text("My Reports"),


            onTap:(){

              Navigator.pop(context);

            },

          ),




          ListTile(

            leading:
              const Icon(
                Icons.add_circle_outline,
              ),


            title:
              const Text(
                "Create Report",
              ),


            onTap: () async {


              Navigator.pop(context); 
              // fermer le Drawer


              final result = await Navigator.pushNamed(
                context,
                "/createReport",
              );


              if(result == true){

                ref
                .read(reportControllerProvider.notifier)
                .loadReports();

              }


            },

          ),


          const Spacer(),




          ListTile(

            leading:
              const Icon(
                Icons.logout,
                color:Colors.red,
              ),


            title:
              const Text(
                "Logout",
                style:
                TextStyle(
                  color:Colors.red,
                ),
              ),


           onTap: () async {

                print("1 - Logout clicked");


                final navigator = Navigator.of(context);


                await ref
                    .read(authControllerProvider.notifier)
                    .logout();


                print("3 - Logout finished");


                navigator.pushNamedAndRemoveUntil(
                  "/login",
                  (route) => false,
                );

              },


          ),


          const SizedBox(height:20)

        ],

      ),

    );

  }


}