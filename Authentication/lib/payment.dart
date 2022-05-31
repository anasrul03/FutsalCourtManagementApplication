import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Payment extends StatefulWidget {
  late DateTime? getData;

  Payment({
    Key? key,
    this.getData,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  // final DateTime? date = widget.getData;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Payment")),
        body: Column(
          children: [
            Container(
              child: TextButton(
                onPressed: () async {
                  sendData();
                  currentIndex = 2;

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                child: Text("TEST NOW"),
              ),
            ),
          ],
        ));
  }

  sendData() async {
    print("Sending Data.....");
    final Map<String, dynamic> data = new Map<String, dynamic>();
    final prefs = await SharedPreferences.getInstance();

    var endDateTime = widget.getData?.add(Duration(hours: 1));
    data['startDate'] = widget.getData;
    data['endDate'] = endDateTime;
    data['createdDate'] = DateTime.now().toString();
    data['userId'] = prefs.getString('userId');
    data['futsalId'] = prefs.getString('futsalId');
    data['courtId'] = prefs.getString('courtId');
    data['futsalTitle'] = prefs.getString('futsalTitle');

    // data['bookId'] = "inspect(data)";

    final bookedDate = FirebaseFirestore.instance
        .collection('UserData')
        .doc(user.email)
        .collection("Booked")
        .doc()
        .set(data);

    // bookedDate.id;
  }
}
