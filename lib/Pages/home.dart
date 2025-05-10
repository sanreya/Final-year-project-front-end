// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'disease.dart';
import 'diet.dart';
import 'reminder.dart';
import 'profile.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeContent(), // Your custom home content with cards
    disease(),
    Diet(),
    ReminderPage(),
  ];

  static const List<String> _titles = [
    "Home",
    "Disease",
    "Diet",
    "Reminder",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.healing), label: 'Disease'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Diet'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminder'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/disease');
              },
              child: Center(child: Text('ASK AI')),
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.green.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/diet');
              },
              child: Center(child: Text('DIET RECOMMENDATION')),
            ),
          ),
        ),
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              splashColor: Colors.red.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/diet');
              },
              child: Center(child: Text('FITNESS RECOMMENDATION')),
            ),
          ),
        ),
      ],
    );
  }
}
