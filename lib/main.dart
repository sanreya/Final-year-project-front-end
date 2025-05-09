import 'package:flutter/material.dart';
import 'package:health/Pages/home.dart';
import 'package:health/Pages/disease.dart';
import 'package:health/Pages/reminder.dart';
import 'package:health/Pages/profile.dart';
import 'package:health/Pages/diet.dart';
import 'package:health/Pages/login.dart';
import 'package:health/Pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const home() : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const home(),
        '/disease': (context) => const disease(),
        '/diet': (context) => const Diet(),
        '/profile': (context) => const Profile(),
        '/reminder': (context) => const ReminderPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
