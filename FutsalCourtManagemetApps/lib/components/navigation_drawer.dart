// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dashboard.dart' as PageIndex;
import '../dashboard.dart';
import '../userProfile_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final alert = "is Logged in";

    return Drawer(
      child: Material(
        color: Colors.blueGrey[900],
        child: ListView(
          children: <Widget>[
            buildHeader(
              name: user.email!,
              email: alert,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfile()),
                );
              },
            ),
            const SizedBox(height: 30),
            buildMenuItem(
              text: "Your Profile",
              icon: Icons.people,
              onClicked: () => selectedItem(context, 0),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Favorite",
              icon: Icons.favorite,
              onClicked: () => selectedItem(context, 1),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Bookings",
              icon: Icons.book,
              onClicked: () => selectedItem(context, 2),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Settings",
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 3),
            ),
            const SizedBox(height: 12),
            buildMenuItem(
              text: "Log out",
              icon: Icons.arrow_back,
              onClicked: () => FirebaseAuth.instance.signOut(),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.white70),
            const SizedBox(height: 24),
            const SizedBox(height: 18),
            buildMenuItem(
              text: "Helps",
              icon: Icons.help,
              onClicked: () => selectedItem(context, 4),
            ),
            const SizedBox(height: 18),
            buildMenuItem(
              text: "Contact Developer",
              icon: Icons.phone,
              onClicked: () => selectedItem(context, 5),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    required onClicked,
  }) {
    // ignore: prefer_const_declarations
    final color = Colors.white;
    // ignore: prefer_const_declarations
    final hoverColor = Colors.white70;

    return ListTile(
        leading: Icon(icon, color: color),
        title: Text(text, style: TextStyle(color: color)),
        hoverColor: hoverColor,
        onTap: onClicked);
  }

  void selectedItem(BuildContext context, int index) {
    //reset drawer after tap on any button
    Navigator.of(context).pop();

    switch (index) {
      case 0: // Your Profile
        //Directed to page you want

        break;
      case 1: //Bookings
        //Directed to page you want
        PageIndex.currentIndex = 1;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 2: //Favorite
        //Directed to page you want
        PageIndex.currentIndex = 2;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 3: //Settings
        //Directed to page you want
        break;
      case 4: //Helps
        //Directed to page you want
        PageIndex.currentIndex = 3;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
        break;
      case 5: //Contact Developer
        //Directed to page you want
        break;
    }
  }

  Widget buildHeader({
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
            padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
            child: Row(children: [
              CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://yt3.ggpht.com/yti/APfAmoEZZKxy7s3xXZ-bgkUvtpJwUxNRnOMP8CTlxIvXng8=s88-c-k-c0x00ffffff-no-rj-mo")),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(email,
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ])
            ])),
      );
}
