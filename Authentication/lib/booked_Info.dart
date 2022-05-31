import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookedInfo extends StatefulWidget {
  final String futsalId;
  final String bookId;
  final String futsalTitle;
  final Timestamp bookTime;
  final String courtId;

  const BookedInfo(
      {Key? key,
      required this.futsalId,
      required this.futsalTitle,
      required this.bookTime,
      required this.courtId,required this.bookId})
      : super(key: key);

  @override
  State<BookedInfo> createState() => _BookedInfoState();
}

class _BookedInfoState extends State<BookedInfo> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime? date1;

  @override
  void initState() {
    // date1 == date;
    setState(() {
      final DateTime date2 =
          DateTime.parse(widget.bookTime.toDate().toString());

      date2 == date1;
      print(date1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Courtify",
                style: GoogleFonts.lato(),
              ),
              SizedBox(width: 3),
              Icon(
                Icons.sports_soccer,
                color: Colors.blue,
              ),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              // SizedBox(height: 20),
              Container(
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // ignore: prefer_const_literals_to_create_immutables
                    colors: [
                      Colors.blueGrey,
                      Colors.black87,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 30),
                    Center(
                      child: Text("THANKS! YOUR BOOKING HAS BEEN MADE",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                              fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    // ignore: prefer_const_constructors
                    Image.asset(
                      "lib/assets/images/dummyQR.png",
                      width: 150,
                      height: 150,
                    ),
                    SizedBox(height: 35),
                    Text(
                      "Book ID: ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Divider(thickness: 1, color: Colors.white),
                    SizedBox(height: 35),
                    Text(
                      "Futsal Name: " + widget.futsalTitle,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    SizedBox(height: 5),
                    Text(
                      "Book Time: " + date1.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Court ID: " + widget.courtId,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Total Payment: ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  test() {
    DateTime.parse(widget.bookTime.toDate().toString());
  }
}
