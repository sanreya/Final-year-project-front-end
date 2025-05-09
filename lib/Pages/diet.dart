import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'diet_results.dart';

class Diet extends StatelessWidget {
  const Diet({super.key});

  Future<void> fetchAndNavigate(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final url = Uri.parse(
    "https://192.168.29.177:8080/api/diet/search?cuisine=Indian&diet=vegetarian&intolerances=peanut,soy&number=10&apiKey=1682f92a122c48b195a8d4ea84643c6d",
  );

  final response = await http.get(
    url,
    headers: {
      'Authorization': token,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DietResults(results: results),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to fetch data")),
    );
  }
}


  Widget buildCard(String title, IconData icon, BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        onTap: () => fetchAndNavigate(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Diet Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildCard("Breakfast", Icons.breakfast_dining, context),
            buildCard("Lunch", Icons.lunch_dining, context),
            buildCard("Dinner", Icons.dinner_dining, context),
          ],
        ),
      ),
    );
  }
}