import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  final habitsController = TextEditingController();
  final diagnosisController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
  final url = Uri.parse(
    'https://final-year-project-production-f1cb.up.railway.app/api/auth/register',
  );

  final Map<String, dynamic> requestBody = {
    "name": nameController.text.trim(),
    "gender": genderController.text.trim(),
    "age": int.tryParse(ageController.text),
    "habits": habitsController.text.trim(),
    "previousDiagnosis": diagnosisController.text.trim(),
    "height": double.tryParse(heightController.text),
    "weight": double.tryParse(weightController.text),
    "email": emailController.text.trim(),
    "username": usernameController.text.trim(),
    "password": passwordController.text.trim(),
  };

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success: Navigate to home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(response.body),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Could not register. Please try again.\n$e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender')),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age')),
            TextField(controller: habitsController, decoration: const InputDecoration(labelText: 'Habits')),
            TextField(controller: diagnosisController, decoration: const InputDecoration(labelText: 'Previous Diagnosis')),
            TextField(controller: heightController, decoration: const InputDecoration(labelText: 'Height')),
            TextField(controller: weightController, decoration: const InputDecoration(labelText: 'Weight')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text('Register')),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Already have an account? Login here"),
            ),
          ],
        ),
      ),
    );
  }
}
