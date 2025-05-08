// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class home extends StatefulWidget{
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(

            children: [
              DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  size : 50
                )
              ),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("PROFILE"),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                }
              ),

              ListTile(
                leading: Icon(Icons.access_alarm),
                title: Text("REMINDER"),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/reminder');
                }  
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("LOGOUT"),
                onTap:(){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                }
              )
            ],
          )
          
        ),
        body: Column(
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
                  child: Center(child: Text('ASK  AI')),
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
                  child: Center(child: Text('DIET  RECOMMENDATION')),
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
        ),  
    );
  }
}

