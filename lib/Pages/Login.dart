import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  final url = Uri.parse(
    'https://final-year-project-production-f1cb.up.railway.app/api/auth/login'
    '?email=$email&password=$password',
  );

  try {
    print('Sending POST request to: $url');

    final response = await http.post(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final token = response.body;

      if (token.startsWith('Bearer ')) {
        // You can store the token if needed using shared_preferences
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorSnackBar('Login failed: Invalid token format');
      }
    } else {
      _showErrorSnackBar('Invalid credentials');
    }
  } catch (e) {
    print('Error occurred: $e');
    _showErrorSnackBar('Something went wrong. Please try again later.');
  }
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}


  void navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text('Login')),
            const SizedBox(height: 10),
            TextButton(
              onPressed: navigateToRegister,
              child: const Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
