// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'disease.dart';
import 'diet.dart';
import 'reminder.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

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
      appBar:  _selectedIndex == 0
          ? AppBar(
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
      ): null,
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
        // ASK AI Card
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Rounded corners
            ),
            elevation: 8, // Shadow effect
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/disease');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'ASK AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                    ),
                    // Right side SVG Icon
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/ai_icon.svg', // Add your SVG asset here
                        height: 40, // Adjust the icon size
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // DIET RECOMMENDATION Card
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: InkWell(
              splashColor: Colors.green.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/diet');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'DIET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Right side SVG Icon
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/diet_icon.svg', // Add your SVG asset here
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // FITNESS RECOMMENDATION Card
        Expanded(
          child: Card(
            margin: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: InkWell(
              splashColor: Colors.red.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, '/fitness');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'FITNESS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Right side SVG Icon
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/fitness_icon.svg', // Add your SVG asset here
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
