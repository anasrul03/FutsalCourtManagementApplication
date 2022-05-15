// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/select_court_slot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_futsal_reference.dart' as futsalReference;

class AllCourt extends StatefulWidget {
  const AllCourt({Key? key}) : super(key: key);

  @override
  State<AllCourt> createState() => _AllCourtState();
}

class _AllCourtState extends State<AllCourt> {
  final String FutsalList = "FutsalList";
  final String title = futsalReference.title;
  final String idpath = futsalReference.direct;

  @override
  void initState() {
    super.initState();
    print(idpath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: StreamBuilder<List<Court>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error} ");
            } else if (snapshot.hasData) {
              final bookings = snapshot.data!;
              return Container(
                  child: ListView(
                children: bookings.map(buildList).toList(),
              ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget buildList(Court court) => GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        // Try reading data from the 'action key. If it doesn't exist, returns null.
        prefs.setString('courtId', court.courtName);
        log(court.courtName);
        setState(() {});
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CourtSlot()),
        );
      },
      child: Card(
          child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          child: ClipRRect(
            child: Text(court.courtName),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        title: Text(court.courtType),
        subtitle: Text("RM${court.price} per Hour"),
      )));

  Stream<List<Court>> readUsers() => FirebaseFirestore.instance
      .collection(idpath)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Court.fromJson(doc.data())).toList());
}

//class created for every collection in firebase database
class Court {
  // the variable to be set the value from the controller
  String id;
  final String courtName;
  final String courtType;
  final int price;

// user requirement information in data table (Firebase Database)
  Court({
    this.id = '',
    required this.courtName,
    required this.courtType,
    required this.price,
  });

  // assigning the data value based on table variable in Firabase Database
  // still don't know how to set and display specific time
  Map<String, dynamic> toJson() => {
        // property in database : variable
        'id': id,
        'name': courtName,
        'type': courtType,
        'price': price,
        // 'imageurl': cover_image_url,
        // 'futsalcourt': futsalCourt,
        // 'date': date,
      };

  //READ data initalization
  static Court fromJson(Map<String, dynamic> json) => Court(
        // id: json['id'],
        courtName: json['name'],
        courtType: json['type'],
        price: json['price'],
        // cover_image_url: json['imageurl'],
        // futsalCourt: json['futsalcourt'],
        // date: (json['date'] as Timestamp).toDate(),
      );
}
