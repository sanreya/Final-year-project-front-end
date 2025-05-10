import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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
    'http://192.168.29.177:8080/api/auth/login?email=$email&password=$password',
  );

  try {
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final token = response.body;

      if (token.startsWith('Bearer ')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token); // Store token

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorSnackBar('Login failed: Invalid token format');
      }
    } else {
      _showErrorSnackBar('Invalid credentials');
    }
  } catch (e) {
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