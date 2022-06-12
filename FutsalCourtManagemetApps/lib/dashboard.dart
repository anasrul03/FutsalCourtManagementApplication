// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_attemp2/search_page.dart';
import 'package:login_attemp2/userProfile_page.dart';

import 'booking_page.dart';

import 'favorite_page.dart';
import 'home_page.dart';

// this is the index for the bottomNavigationBar
int currentIndex = 0;
// this is the screen based on the selected index on BottomNavigationBar
final screens = [
  //Index = 0
  SearchPage(),
  //Index = 1
  booking_page(),
  //Index = 2
  favorite_page(),
  //Index = 3
  UserProfile(),
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
      // drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Courtify",
              style: GoogleFonts.lato(),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.sports_soccer,
              color: Colors.blue,
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.black,
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
            icon: Icon(Icons.book),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
