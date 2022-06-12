// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'bookedlist.dart';

// ignore: camel_case_types
class booking_page extends StatefulWidget {
  const booking_page({Key? key}) : super(key: key);

  @override
  State<booking_page> createState() => _booking_pageState();
}

// ignore: camel_case_types
class _booking_pageState extends State<booking_page> {
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
                      "https://www.samoanews.com/sites/default/files/styles/article_normal_image/public/field/image/Jr%20Action_6263.jpg?itok=4FpdN2HK",
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
                      Text("Recent Bookings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                          )),
                      SizedBox(height: 7),
                      Text("Make sure you has made a booking",
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
            Flexible(child: BookedList()),
          ],
        ));
  }

  Widget buildLists(Book bookData) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () async {},
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: ListTile(
            // leading: Image.network(
            //     "https://yt3.ggpht.com/ytc/AKedOLTgR4UeiRqyy3zdHFHpSGKgu5xCYSeeMGxv5cxBUA=s900-c-k-c0x00ffffff-no-rj"),
            title: Text('You have booked court ' + bookData.courtId),
            subtitle: Text(bookData.endDate.toString()),
          )));

  Stream<List<Book>> getBookedList() => FirebaseFirestore.instance
      .collection('Booked')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            log(doc.id);
            // log('called getBookedList ');
            return Book.fromJson(doc.data());
          }).toList());
}

class Book {
  final Timestamp startDate;
  final Timestamp endDate;
  final String userId;
  final String futsalId;
  final String courtId;

  Book({
    required this.startDate,
    required this.endDate,
    required this.userId,
    required this.futsalId,
    required this.courtId,
  });

  static Book fromJson(Map<String, dynamic> json) => Book(
        startDate: json['startDate'],
        endDate: json['endDate'],
        userId: json['userId'],
        futsalId: json['futsalId'],
        courtId: json['courtId'],
      );

  Map<String, dynamic> toJson() => {
        'endDate': endDate,
        'startDate': startDate,
        'userId': userId,
        'futsalId': futsalId,
        'courtId': courtId,
      };
}
