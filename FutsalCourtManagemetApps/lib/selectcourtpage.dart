// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_court_reference.dart';

class SelectCourt extends StatefulWidget {
  final String futsalIdFav;
  final String futsalTitle;
  final String futsalAddress;
  final String imageurl;
  const SelectCourt({
    Key? key,
    required this.futsalIdFav,
    required this.futsalAddress,
    required this.futsalTitle,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<SelectCourt> createState() => _SelectCourtState();
}

class _SelectCourtState extends State<SelectCourt> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          title: Text("Select Court"),
          actions: [
            IconButton(
                tooltip: "Like!",
                onPressed: () {
                  Favorite(widget.futsalIdFav);
                },
                icon: Icon(Icons.favorite)),
          ],
        ),
        body: Column(
          children: [
            Stack(
              textDirection: TextDirection.ltr,
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, 190));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(widget.imageurl,
                      fit: BoxFit.fill, height: 200, width: double.infinity),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 130),
                      Text(widget.futsalTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(height: 7),
                      Text("Every court has a different price per hour",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: AllCourt(
                futsalId: widget.futsalIdFav,
                futsalTitle: widget.futsalTitle,
                imageURL: widget.imageurl,
              ),
            ),
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  Future Favorite(String futsalIdFav) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      FirebaseFirestore.instance
          .collection('UserData')
          .doc(user.email)
          .collection("Favorite")
          .doc(futsalIdFav)
          .set({
        "userId": user.uid,
        "futsalId": futsalIdFav,
        "imageURL": widget.imageurl,
        "address": widget.futsalAddress,
        "futsalTitle": widget.futsalTitle
      });
      print(futsalIdFav);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text("Added to favorite"),
        duration: Duration(milliseconds: 100),
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
      // print("already registered");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Your email already registered !!"),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
