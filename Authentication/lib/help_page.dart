// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class help_page extends StatefulWidget {
  const help_page({Key? key}) : super(key: key);

  @override
  State<help_page> createState() => _help_pageState();
}

// ignore: camel_case_types
class _help_pageState extends State<help_page> {
  final bookingIdController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    bookingIdController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 900,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            heightFactor: 2,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  Text(
                    "Did not find the booking you were looking for?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Input your Booking ID of an advance info that might help us to track your problem.(your booking id shown in your booked list)",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 40),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(23.0),
                            shadowColor: Color(0x55434343),
                            child: TextFormField(
                              controller: bookingIdController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                hintText: "Insert your booking ID...",
                                prefixIcon: Icon(
                                  Icons.book,
                                  color: Colors.black54,
                                ),
                                border: InputBorder.none,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter your book id please'
                                      : null,
                            ),
                          ),
                          SizedBox(height: 10),
                          Material(
                            borderRadius: BorderRadius.circular(23.0),
                            shadowColor: Color(0x55434343),
                            child: TextFormField(
                              controller: descriptionController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                hintText: "Describe your issues...",
                                border: InputBorder.none,
                              ),
                              maxLines: 10,
                              minLines: 1,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter some description!'
                                      : null,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 17, horizontal: 20),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            sendReport(
                                bookingIdController, descriptionController);
                          },
                          child: Text("Submit",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future sendReport(TextEditingController bookingIdController,
      TextEditingController descriptionController) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;

      FirebaseFirestore.instance.collection('ReportList').doc().set({
        "createdDate": DateTime.now(),
        "bookingID": bookingIdController.text.trim(),
        "description": descriptionController.text.trim(),
        "userId": user.uid,
        "userEmail": user.email,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully send report"),
        duration: Duration(seconds: 3),
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
      // print("already registered");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Your email already registered !!"),
        duration: Duration(seconds: 3),
      ));
    }
  }
}

class Report {
  final String bookingID;
  final String issue;
  final String userId;

  Report({required this.bookingID, required this.issue, required this.userId});

  static Report fromJson(Map<String, dynamic> json) => Report(
      bookingID: json['bookingID'],
      issue: json['issue'],
      userId: json['userId']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingID'] = this.bookingID;
    data['issue'] = this.issue;
    data['userId'] = this.userId;

    return data;
  }
}
