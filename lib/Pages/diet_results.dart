import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DietResults extends StatelessWidget {
  final List results;

  const DietResults({super.key, required this.results});

  void fetchRecipeDetails(BuildContext context, int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse("https://final-year-project-production-f1cb.up.railway.app/api/diet/$id");

    print("Sending GET request to: $url");
    print("Authorization: Bearer $token");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Recipe Details"),
            content: Text(data.toString()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load recipe")),
        );
      }
    } catch (e) {
      print("Error fetching recipe: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recipe List")),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return ListTile(
            leading: Image.network(item['image'], width: 60, fit: BoxFit.cover),
            title: Text(item['title']),
            onTap: () => fetchRecipeDetails(context, item['id']),
          );
        },
      ),
    );
  }
}
