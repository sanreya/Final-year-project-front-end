import 'package:flutter/material.dart';
import 'package:health/Pages/home.dart';
import 'package:health/Pages/disease.dart';
import 'package:health/Pages/reminder.dart';
import 'package:health/Pages/profile.dart';
import 'package:health/Pages/diet.dart';
import 'package:health/Pages/login.dart';
import 'package:health/Pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => const home(),
        '/disease' : (context) => disease(),
        '/diet' : (context) => diet(),
        '/profile' : (context) => profile(),
        '/reminder' : (context) => reminder(),
        '/register' : (context) => RegisterPage(),
      }
    );
  }
}
