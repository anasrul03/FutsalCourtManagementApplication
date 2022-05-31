// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import 'favoriteList.dart';

// ignore: camel_case_types
class favorite_page extends StatefulWidget {
  const favorite_page({Key? key}) : super(key: key);

  @override
  State<favorite_page> createState() => _favorite_pageState();
}

// ignore: camel_case_types
class _favorite_pageState extends State<favorite_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, 180));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                      "https://static.wixstatic.com/media/64997e_d3ca7baae6f945aea946a4f5e11cbd11~mv2.jpg/v1/fill/w_640,h_402,al_b,q_80,usm_0.66_1.00_0.01,enc_auto/64997e_d3ca7baae6f945aea946a4f5e11cbd11~mv2.jpg",
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 120),
                      Text("Favorites Arena",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(height: 7),
                      Text("Quick saved your favorite list ",
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
            Flexible(child: FavoriteList()),
          ],
        ));
  }
}
