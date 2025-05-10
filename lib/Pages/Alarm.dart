import 'package:flutter/material.dart';
class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alarm")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Time to take your medicine!", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Dismiss the alarm
                Navigator.pop(context);
              },
              child: Text("Dismiss", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
