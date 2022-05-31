import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booked_Info.dart';

class BookedList extends StatefulWidget {
  const BookedList({Key? key}) : super(key: key);

  @override
  State<BookedList> createState() => _BookedListState();
}

class _BookedListState extends State<BookedList> {
  final user = FirebaseAuth.instance.currentUser!;

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
            final bookedlist = snapshot.data!;

            return ListView(
              children: bookedlist.map(buildLists).toList(),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget buildLists(Book bookData) => GestureDetector(
        //when clicked it will directed based on database
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookedInfo(
                      bookId: "bookData.id",
                      futsalId: bookData.futsalId,
                      courtId: bookData.courtId,
                      futsalTitle: bookData.futsalTitle,
                      bookTime: bookData.startDate,
                    )),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Card(
              color: Colors.blueGrey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.assignment_outlined,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  bookData.futsalTitle,
                  style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                subtitle: Text("Court" + bookData.courtId,
                    style: TextStyle(color: Colors.white60, fontSize: 10)),
                trailing: Text(
                  bookData.courtId,
                  style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              )),
        ),
      );

  Stream<List<Book>> getBookedList() => FirebaseFirestore.instance
      .collection('UserData')
      .doc(user.email)
      .collection("Booked")
      .orderBy("createdDate", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // log(doc.id);
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
  final String futsalTitle;
  final String bookId;

  Book({
    required this.startDate,
    required this.endDate,
    required this.userId,
    required this.futsalId,
    required this.courtId,
    required this.futsalTitle,
    required this.bookId,
  });

  static Book fromJson(Map<String, dynamic> json) => Book(
        startDate: json['startDate'],
        endDate: json['endDate'],
        userId: json['userId'],
        futsalId: json['futsalId'],
        courtId: json['courtId'],
        futsalTitle: json['futsalTitle'],
        bookId: json['bookId'],
      );

  Map<String, dynamic> toJson() => {
        'endDate': endDate,
        'startDate': startDate,
        'userId': userId,
        'futsalId': futsalId,
        'courtId': courtId,
        'bookId': bookId
      };
}
