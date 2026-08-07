import 'package:flutter/material.dart';
import 'package:frontend/core/api_client.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();           // Initialisation des cookies
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      initialRoute: AppRoutes.login,           
      routes: AppRoutes.routes,
    );
  }
}