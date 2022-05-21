// ignore_for_file: prefer_const_constructors, camel_case_types

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:login_attemp2/all_futsal_reference.dart';
import 'package:login_attemp2/promotion_page.dart';
import 'components/futsalCard.dart';

class home_page extends StatefulWidget {
  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            //Let's start by adding the text
            Text(
              "Welcome Futsal Player",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "Book your futsal arena",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            //Now let's add some elevation to our text field
            //to do this we need to wrap it in a Material widget
            Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: "Search for Futsal, Venue...",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            //Now let's Add a Tabulation bar
            DefaultTabController(
              length: 3,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.blue,
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                      // ignore: prefer_const_literals_to_create_immutables
                      tabs: [
                        Tab(
                          text: "Courts",
                        ),
                        Tab(
                          text: "Promotion",
                        ),
                        Tab(
                          text: "Tournament",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          //First index(TABS)
                          AllFutsal(),
                          //tabs 2
                          PromotionList(
                             
                          ),
                          //tabs 3
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://media.istockphoto.com/photos/football-futsal-ball-goal-and-floor-indoor-soccer-sports-hall-sport-picture-id1198313297?k=20&m=1198313297&s=612x612&w=0&h=N7JPfxpLNw9DYHcH3xkc_fY8Wx4QGSQfRYwWwl46YRY="),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
