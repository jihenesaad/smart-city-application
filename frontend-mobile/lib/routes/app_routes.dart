import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/create_report_screen.dart';
import 'package:frontend/presentation/screens/home_screen.dart';
import 'package:frontend/presentation/screens/login_screen.dart';
import 'package:frontend/presentation/screens/register_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context)=> const HomeScreen(),
    "/createReport": (context) => const CreateReportScreen(),
  };
}