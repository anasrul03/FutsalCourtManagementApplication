import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/home_page.dart';
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
          id: list[i]["id"],
          cover_image_url: list[i]["imageurl"],
          futsalName: list[i]["name"]));
    }

    inspect(futsal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: home_page(),
    );
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
        FocusScope.of(context).unfocus();
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
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
            .where((element) =>
                element.futsalName.toLowerCase().contains(query) ||
                element.address.toLowerCase().contains(query))
            .toList();

    log(suggestionList.length.toString());

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.sports_soccer, color: Colors.grey),
        subtitle: RichText(
          text: TextSpan(
            text: suggestionList[index].address.substring(0, query.length),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            children: [
              TextSpan(
                text: suggestionList[index].address.substring(query.length),
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
              )
            ],
          ),
        ),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          // Save an String value to 'action' key.
          await prefs.setString('futsalTitle', futsal[index].futsalName);
          // await prefs.setString('futsalId', futsal[index].id);

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

          inspect(futsal[index].address);
        },
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].futsalName.substring(0, query.length),
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
