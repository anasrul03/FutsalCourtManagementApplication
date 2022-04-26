// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'all_court_reference.dart';


//Variable that been shared to other file(allcourt)
late String direct;
String title = '';

class AllFutsal extends StatefulWidget {
  const AllFutsal({Key? key}) : super(key: key);

  @override
  State<AllFutsal> createState() => AllFutsalState();
}

class AllFutsalState extends State<AllFutsal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.black,
      body: StreamBuilder<List<Futsal>>(
        stream: getFutsalList(),
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

  Widget buildList(Futsal futsal) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () {
        setState(() {

          //Setting the variable that can change direction court list 
          direct = "FutsalList/${futsal.id}/Courts";
          title = futsal.futsalName;

          
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllCourt()),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
          child: ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          child: ClipRRect(
            child: Image.network(
              futsal.cover_image_url,
              height: 150.0,
              width: 100.0,
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        title: Text(futsal.futsalName),
        subtitle: Text(futsal.address),
      )));

  Stream<List<Futsal>> getFutsalList() => FirebaseFirestore.instance
      .collection('FutsalList')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Futsal.fromJson(doc.data())).toList());
}

//class created for every collection in firebase database
class Futsal {
  // the variable to be set the value from the controller
  final String id;
  final String futsalName;
  final String address;
  final String cover_image_url;

// user requirement information in data table (Firebase Database)
  Futsal({
    this.id = '',
    required this.futsalName,
    required this.address,
    required this.cover_image_url,
  });

  // assigning the data value based on table variable in Firabase Database
  // still don't know how to set and display specific time
  Map<String, dynamic> toJson() => {
        // property in database : variable
        'id': id,
        'name': futsalName,
        'address': address,
        'imageurl': cover_image_url,
        // 'futsalcourt': futsalCourt,
        // 'date': date,
      };

  //READ data initalization
  static Futsal fromJson(Map<String, dynamic> json) => Futsal(
        futsalName: json['name'],
        address: json['address'],
        cover_image_url: json['imageurl'],
        // futsalCourt: json['futsalcourt'],
        // date: (json['date'] as Timestamp).toDate(),
        id: json['id'],
      );
}


