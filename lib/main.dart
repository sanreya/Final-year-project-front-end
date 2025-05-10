import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as _tz;
import 'package:health/Pages/home.dart';
import 'package:health/Pages/Alarm.dart';
import 'package:health/Pages/disease.dart';
import 'package:health/Pages/reminder.dart';
import 'package:health/Pages/profile.dart';
import 'package:health/Pages/diet.dart';
import 'package:health/Pages/login.dart';
import 'package:health/Pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize timezone
  tz.initializeTimeZones();
  final location = _tz.getLocation('Asia/Kolkata');
  _tz.setLocalLocation(location);
  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


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
        '/alarm': (context) => AlarmScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const home(),
        '/disease': (context) => const disease(),
        '/diet': (context) => const Diet(),
        '/profile': (context) => const Profile(),
        '/reminder': (context) => ReminderPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
