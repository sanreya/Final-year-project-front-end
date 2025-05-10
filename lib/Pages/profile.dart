import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? gender;
  int? age;
  String? habits;
  String? previousDiagnosis;
  double? height;
  double? weight;
  String? email;
  String? username;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('token'); // Retrieve the access token

    if (accessToken == null) {
      // Handle the case where the access token is not found
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse("http://192.168.29.177:8080/api/auth/profile"),
      headers: {
        'Authorization': '$accessToken', // Pass the access token in the header
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        name = data["name"];
        gender = data["gender"];
        age = data["age"];
        habits = data["habits"];
        previousDiagnosis = data["previousDiagnosis"];
        height = data["height"];
        weight = data["weight"];
        email = data["email"];
        username = data["username"];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Optionally handle other status codes (e.g., 401 Unauthorized)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ProfileDetailRow(title: "Name", value: name ?? "Loading..."),
                  ProfileDetailRow(title: "Gender", value: gender ?? "Loading..."),
                  ProfileDetailRow(title: "Age", value: age?.toString() ?? "Loading..."),
                  ProfileDetailRow(title: "Habits", value: habits ?? "Loading..."),
                  ProfileDetailRow(title: "Previous Diagnosis", value: previousDiagnosis ?? "Loading..."),
                  ProfileDetailRow(title: "Height", value: height != null ? "${height!} cm" : "Loading..."),
                  ProfileDetailRow(title: "Weight", value: weight != null ? "${weight!} kg" : "Loading..."),
                  ProfileDetailRow(title: "Email", value: email ?? "Loading..."),
                  ProfileDetailRow(title: "Username", value: username ?? "Loading..."),
                ],
              ),
            ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
