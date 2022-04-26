// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';


import 'booking_page.dart';
import 'components/navigation_drawer.dart';
import 'favorite_page.dart';
import 'help_page.dart';
import 'home_page.dart';

 // this is the index for the bottomNavigationBar
  int currentIndex = 0;
  // this is the screen based on the selected index on BottomNavigationBar
   final screens = [
    //Index = 0
    home_page(),
    //Index = 1
    favorite_page(),
    //Index = 2
    booking_page(),
    //Index = 3
    help_page(),
  ];

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Dashboard(),
  ));
}

// ignore: use_key_in_widget_constructors
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            
          ],
        ),
      ),
      body: IndexedStack(
        //this indexedstack will keep the state when you directed to another page.
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: "Help",
          ),
        ],
      ),
    );
  }
}
