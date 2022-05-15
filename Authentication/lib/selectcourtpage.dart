// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'all_court_reference.dart';
import 'all_futsal_reference.dart' as futsalReference;

class SelectCourt extends StatefulWidget {
  const SelectCourt({Key? key}) : super(key: key);

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
            title: Text(futsalReference.title)),
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
                  child: Image.network(futsalReference.imageurl,
                      fit: BoxFit.fill, height: 200, width: double.infinity),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 150),
                      Text("Select your perfect Court",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Flexible(
              child: AllCourt(),
            ),
          ],
        ));
  }
}
