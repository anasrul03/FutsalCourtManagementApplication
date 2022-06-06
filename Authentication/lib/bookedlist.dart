import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booked_Info.dart';
import 'constants/DateParsers.dart';

class BookedList extends StatefulWidget {
  const BookedList({Key? key}) : super(key: key);

  @override
  State<BookedList> createState() => _BookedListState();
}

class _BookedListState extends State<BookedList> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('UserData')
              .doc(user.email)
              .collection("Booked")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
              itemBuilder: (context, index) {
                final data = Book.fromSnapshot(snapshot.data!.docs[index]);

                var uid = snapshot.data!.docs[index];
                return buildLists(data, uid.id, context);
              },
            );
          },
        ));
  }
}

Widget buildLists(data, uid, context) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookedInfo(
                    bookId: uid,
                    futsalId: data.futsalId,
                    courtId: data.courtId,
                    futsalTitle: data.futsalTitle,
                    bookTime: data.startDate,
                    totalPayment: data.totalPayment,
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
              leading: const Icon(
                Icons.assignment_outlined,
                color: Colors.white,
                size: 30,
              ),
              title: Text(
                data.futsalTitle,
                style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              subtitle: Text(DateParser.parseDateTimeyMMMMd(data.startDate),
                  style: const TextStyle(color: Colors.white60, fontSize: 10)),
              trailing: Text(
                data.courtId,
                style: const TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            )),
      ),
    );

class Book {
  String? bookId;
  Timestamp? startDate;
  Timestamp? endDate;
  String? userId;
  String? userEmail;
  String? futsalId;
  String? courtId;
  String? futsalTitle;
  int? totalPayment;

  Book(
      {this.bookId,
      this.startDate,
      this.endDate,
      this.userId,
      this.userEmail,
      this.futsalId,
      this.courtId,
      this.futsalTitle,
      this.totalPayment});

  String toRawJson() => json.encode(toJson());

  factory Book.fromSnapshot(DocumentSnapshot snapshot) {
    final model = Book.fromJson(snapshot.data() as Map<String, dynamic>);
    return model;
  }

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        totalPayment: json["paymentTotal"],
        bookId: json["id"],
        startDate: json["startDate"],
        courtId: json["courtId"],
        futsalTitle: json["futsalTitle"],
        futsalId: json["futsalId"],
      );

  Map<String, dynamic> toJson() => {
        "startDate": startDate,
        "id": bookId,
      };
}
