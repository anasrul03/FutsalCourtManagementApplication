import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/selectcourtpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_futsal_reference.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

late List<Futsal> futsal = [];

class _SearchPageState extends State<SearchPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    getFutsal();
    super.initState();
  }

  getFutsal() async {
    QuerySnapshot querySnapshot = await db.collection("FutsalList").get();
    var list = querySnapshot.docs;
    // log(list[1]["name"]);

    for (var i = 0; i < list.length; i++) {
      futsal.add(Futsal(
          address: list[i]["address"],
          cover_image_url: list[i]["imageurl"],
          futsalName: list[i]["name"]));
    }

    inspect(futsal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          inspect(futsal);
          showSearch(context: context, delegate: DataSearch());
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.search, color: Colors.black),
      ),
    );
  }

  Future<List<Futsal>> curUserData() {
    return db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) =>
            Futsal.fromJson(snapshot.data()!))
        .toList();
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    //actions
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  Widget forIcon(String icon) {
    log(icon);
    switch (icon) {
      case 'class':
        return Icon(Icons.class_);
      case 'student':
        return Icon(Icons.person);
      case 'coach':
        return Icon(Icons.directions_run_rounded);
      default:
        return Icon(Icons.access_time_filled_sharp);
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Futsal> suggestionList = query.isEmpty
        ? futsal
        : futsal
            .where((element) => element.futsalName.startsWith(query))
            .toList();

    log(suggestionList.length.toString());

    // return ListView.builder(
    //     itemCount: suggestionList.length,
    //     itemBuilder: (context, index) => ListTile(
    //           title: Text(suggestionList[index].address),
    //           onTap: () async {
    //             // showResults(context);
    //           },
    //         ));

    //show primary results widget
    // final suggestionList = query.isEmpty
    //     ? futsal
    //     : futsal.where((element) => element.name!.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          // Save an String value to 'action' key.
          await prefs.setString('futsalTitle', futsal[index].futsalName);
          await prefs.setString('futsalId', futsal[index].id);
// setState(() {
//           //Setting the variable that can change direction court list
//           direct = "FutsalList/${futsal.id}/Courts";

//           title = futsal.futsalName;
//           imageurl = futsal.cover_image_url;
//         });
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectCourt(
                      futsalIdFav: futsal[index].id,
                      futsalAddress: futsal[index].address,
                      futsalTitle: futsal[index].futsalName,
                      imageurl: futsal[index].cover_image_url,
                    )),
          );
        },
        // leading: Icon(Icons.abc_outlined),
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].futsalName.substring(0, query.length),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: suggestionList[index].futsalName.substring(query.length),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
