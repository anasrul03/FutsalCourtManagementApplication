// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_attemp2/help_page.dart';
import 'package:login_attemp2/userProfile_edit.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final double heightSpace = 10;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Stack(
                  children: [
                    Card(
                      // elevation: 20.0,
                      // shadowColor: Color(0x55434343),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // ignore: prefer_const_literals_to_create_immutables
                            colors: [
                              Colors.blueGrey,
                              Colors.black87,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 190),
                              // ignore: prefer_const_constructors

                              SizedBox(height: heightSpace),
                              Card(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileEdit())),
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Edit my account'),
                                    trailing: Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ),
                              Card(
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => help_page())),
                                  child: ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Help Assistant'),
                                    trailing: Icon(Icons.arrow_forward),
                                  ),
                                ),
                              ),

                              SizedBox(height: heightSpace),
                              GestureDetector(
                                onTap: () => FirebaseAuth.instance.signOut(),
                                child: Card(
                                  color: Colors.red,
                                  child: ListTile(
                                    title: Center(
                                      child: Text('Log out',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.8),
                      child: Stack(
                        children: [
                          ClipRRect(
                              child: Image.network(
                                "https://media.istockphoto.com/photos/abstract-background-color-gradient-light-blue-white-picture-id1269552168?k=20&m=1269552168&s=612x612&w=0&h=rFTFroan14_py5CI8ZWuZNFYXuvizmbLESMavGx2NnA=",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8))),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                    radius: 50,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                    )),
                                SizedBox(height: 11),
                                // Text(user.uid, style: GoogleFonts.lato()),
                                Text(user.email!,
                                    style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                )
              ]))),
    );
  }
}
