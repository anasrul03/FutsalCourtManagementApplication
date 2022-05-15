// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      body: StreamBuilder<List<Book>>(
        stream: getBookedList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            inspect(snapshot.error);

            return Text("Something went wrong! ${snapshot.error} ");
          } else if (snapshot.hasData) {
            log('has data');
            final bookedlist = snapshot.data!;

            return ListView(
              children: bookedlist.map(buildLists).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
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
            title: Text('You have booked court '+bookData.courtId),
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
