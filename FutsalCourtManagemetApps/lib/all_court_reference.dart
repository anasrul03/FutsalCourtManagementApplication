// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/select_court_slot.dart';
import 'package:shared_preferences/shared_preferences.dart';

String courtTitle = '';

class AllCourt extends StatefulWidget {
  final String futsalId;
  final String imageURL;
  final String futsalTitle;
  const AllCourt(
      {Key? key,
      required this.futsalId,
      required this.imageURL,
      required this.futsalTitle})
      : super(key: key);

  @override
  State<AllCourt> createState() => _AllCourtState();
}

class _AllCourtState extends State<AllCourt> {
  final String FutsalList = "FutsalList";

  @override
  void initState() {
    super.initState();
    // print(idpath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StreamBuilder<List<Court>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error} ");
          } else if (snapshot.hasData) {
            final bookings = snapshot.data!;
            return ListView(
              children: bookings.map(buildList).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildList(Court court) => GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        // Try reading data from the 'action key. If it doesn't exist, returns null.
        prefs.setString('courtId', court.courtName);
        prefs.setInt('price', court.price);
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['courtId'] = prefs.getString('courtId');
        // data['price'] = prefs.getString('price');

        log(court.courtName);
        final price = int.parse(court.price.toString());

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CourtSlot(
                    courtName: court.courtName,
                    futsalTitle: widget.futsalTitle,
                    imageurl: widget.imageURL,
                    pricePerHour: court.price, courtType: court.courtType,
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
        child: Card(
            color: Colors.blueGrey[900],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: ClipRRect(
                  child: Text(court.courtName,
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              trailing: Icon(Icons.arrow_forward, color: Colors.white),
              title:
                  Text(court.courtType, style: TextStyle(color: Colors.white)),
              subtitle: Text("RM${court.price} per Hour",
                  style: TextStyle(color: Colors.white60)),
            )),
      ));

  Stream<List<Court>> readUsers() => FirebaseFirestore.instance
      .collection("FutsalList")
      .doc(widget.futsalId)
      .collection("Courts")
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
