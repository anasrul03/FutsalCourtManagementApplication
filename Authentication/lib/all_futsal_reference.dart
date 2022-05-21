// ignore_for_file: non_constant_identifier_names



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/selectcourtpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Variable that been shared to other file(allcourt)
late String direct;
String title = '';
String imageurl = '';

class AllFutsal extends StatefulWidget {
  const AllFutsal({Key? key}) : super(key: key);

  @override
  State<AllFutsal> createState() => AllFutsalState();
}

class AllFutsalState extends State<AllFutsal> {
  double height = 72, width = 110;
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
            final futsallist = snapshot.data!;

            return ListView(
              
              children: futsallist.map(buildList).toList(),
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
      onTap: () async {
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        // Save an String value to 'action' key.
        await prefs.setString('futsalId', futsal.id);
        
        setState(() {
          //Setting the variable that can change direction court list
          direct = "FutsalList/${futsal.id}/Courts";
          title = futsal.futsalName;
          imageurl = futsal.cover_image_url;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectCourt()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: [
            Card(
                color: Colors.blueGrey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  
                  selectedTileColor: Colors.white,
                  leading: SizedBox(height: height, width: width - 7),
                  title: Text(futsal.futsalName,
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(futsal.address,
                      style: TextStyle(color: Colors.white60, fontSize: 10)),
                )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                  child: Image.network(
                    futsal.cover_image_url,
                    height: height,
                    width: width,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))),
            ),
          ],
        ),
      ));

  Stream<List<Futsal>> getFutsalList() => FirebaseFirestore.instance
      .collection('FutsalList')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // inspect(doc.data());
            // log(doc.id);

            return Futsal.fromJson(doc.data());
          }).toList());
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
