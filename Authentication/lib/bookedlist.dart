import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookedList extends StatefulWidget {
  const BookedList({Key? key}) : super(key: key);

  @override
  State<BookedList> createState() => _BookedListState();
}

class _BookedListState extends State<BookedList> {
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        child: Card(
            color: Colors.blueGrey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              // leading: Image.network(
              //     "https://yt3.ggpht.com/ytc/AKedOLTgR4UeiRqyy3zdHFHpSGKgu5xCYSeeMGxv5cxBUA=s900-c-k-c0x00ffffff-no-rj"),
              title: Text(
                'You have booked court ' + bookData.courtId,
                style: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              subtitle: Text(bookData.endDate.toString(),
                  style: TextStyle(color: Colors.white60, fontSize: 10)),
            )),
      ));

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
