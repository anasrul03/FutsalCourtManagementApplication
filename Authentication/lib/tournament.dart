import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TournamentList extends StatefulWidget {
  const TournamentList({Key? key}) : super(key: key);

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  double height = 72, width = 110;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<Tournament>>(
        stream: getTournamentList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error} ");
          } else if (snapshot.hasData) {
            final promotionList = snapshot.data!;

            return ListView(
              children: promotionList.map(buildList).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildList(Tournament tournament) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () async {
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        // Save an String value to 'action' key.
        await prefs.setString('tournamentId', tournament.id.toString());

        setState(() {
          //Setting the variable that can change direction court list
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const SelectCourt()),
        // );
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
                child: Container(
                  height: 150,
                  child: ListTile(
                    isThreeLine: true,
                    selectedTileColor: Colors.white,
                    leading: SizedBox(height: height, width: width - 7),
                    title: Text(tournament.title.toString(),
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(tournament.subtitle.toString(),
                        style: TextStyle(color: Colors.white60, fontSize: 10)),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                  child: Image.network(
                    tournament.imageurl.toString(),
                    height: 150,
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

  Stream<List<Tournament>> getTournamentList() => FirebaseFirestore.instance
      .collection('TournamentList')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // inspect(doc.data());
            // log(doc.id);

            return Tournament.fromJson(doc.data());
          }).toList());
}

class Tournament {
  String? id;
  String? imageurl;
  String? subtitle;
  String? title;

  Tournament({this.id, this.imageurl, this.subtitle, this.title});

  Tournament.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageurl = json['imageurl'];
    subtitle = json['subtitle'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageurl'] = this.imageurl;
    data['subtitle'] = this.subtitle;
    data['title'] = this.title;
    return data;
  }
}
