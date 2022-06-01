// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:login_attemp2/all_futsal_reference.dart';
import 'package:login_attemp2/promotion_page.dart';
import 'package:login_attemp2/tournament.dart';

import 'search_page.dart';
// import 'components/futsalCard.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
          child: Column(
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
                      ).createShader(Rect.fromLTRB(0, 0, rect.width, 150));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                        "https://www.decathlon-united.media/media/sportfolios/assets/img/s01/football/decathlon-futsal.webp",
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        SizedBox(height: 50),
                        Text(
                          "Welcome Futsal Player",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
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
                        SizedBox(height: 30),
                        Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(30.0),
                          shadowColor: Color(0x55434343),
                          child: TextField(
                            onTap: () {
                              showSearch(
                                  context: context, delegate: DataSearch());
                            },
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Search for Futsal, Venue...",
                              hintStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                            PromotionList(),
                            //tabs 3
                            TournamentList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )

          //  Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     //Let's start by adding the text
          //     Text(
          //       "Welcome Futsal Player",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 26.0,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     Text(
          //       "Book your futsal arena",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.w300,
          //       ),
          //     ),
          //     SizedBox(
          //       height: 40.0,
          //     ),
          //     //Now let's add some elevation to our text field
          //     //to do this we need to wrap it in a Material widget
          //     Material(
          //       elevation: 10.0,
          //       borderRadius: BorderRadius.circular(30.0),
          //       shadowColor: Color(0x55434343),
          //       child: TextField(
          //         onTap: () {
          //           showSearch(context: context, delegate: DataSearch());
          //         },
          //         textAlign: TextAlign.start,
          //         textAlignVertical: TextAlignVertical.center,
          //         decoration: InputDecoration(
          //           hintText: "Search for Futsal, Venue...",
          //           prefixIcon: Icon(
          //             Icons.search,
          //             color: Colors.black54,
          //           ),
          //           border: InputBorder.none,
          //         ),
          //       ),
          //     ),
          //     SizedBox(height: 20.0),
          //     //Now let's Add a Tabulation bar
          //     DefaultTabController(
          //       length: 3,
          //       child: Expanded(
          //         child: Column(
          //           children: [
          //             TabBar(
          //               indicatorColor: Colors.blue,
          //               unselectedLabelColor: Colors.white,
          //               labelColor: Colors.blue,
          //               labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
          //               // ignore: prefer_const_literals_to_create_immutables
          //               tabs: [
          //                 Tab(
          //                   text: "Courts",
          //                 ),
          //                 Tab(
          //                   text: "Promotion",
          //                 ),
          //                 Tab(
          //                   text: "Tournament",
          //                 ),
          //               ],
          //             ),
          //             SizedBox(
          //               height: 5.0,
          //             ),
          //             Expanded(
          //               child: TabBarView(
          //                 children: [
          //                   //First index(TABS)
          //                   AllFutsal(),
          //                   //tabs 2
          //                   PromotionList(),
          //                   //tabs 3
          //                   TournamentList(),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          ),
    );
  }

  // Stream<userInfo> getUserInfo() => FirebaseFirestore.instance
  //     .collection('UserData')
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) {
  //           return userInfo.fromJson(doc.data());
  //         }));
}

class userInfo {
  final String email;
  final String phoneNumber;
  final String nickname;
  final String userId;

  userInfo(
      {required this.email,
      required this.phoneNumber,
      required this.nickname,
      required this.userId});

  static userInfo fromJson(Map<String, dynamic> json) => userInfo(
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        nickname: json['nickname'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['nickname'] = this.nickname;
    data['userId'] = this.userId;
    return data;
  }
}
