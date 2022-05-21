import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromotionList extends StatefulWidget {
  const PromotionList({Key? key}) : super(key: key);

  @override
  State<PromotionList> createState() => _PromotionListState();
}

class _PromotionListState extends State<PromotionList> {
  double height = 72, width = 110;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<Promotion>>(
        stream: getPromotionList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error} ");
          } else if (snapshot.hasData) {
            log('has data');
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

  Widget buildList(Promotion promotion) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () async {
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        // Save an String value to 'action' key.
        await prefs.setString('promotionId', promotion.id);

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
                child: ListTile(
                  selectedTileColor: Colors.white,
                  leading: SizedBox(height: height, width: width - 7),
                  title: Text(promotion.title,
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(promotion.subtitle,
                      style: TextStyle(color: Colors.white60, fontSize: 10)),
                )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                  child: Image.network(
                    promotion.imageurl,
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
  Stream<List<Promotion>> getPromotionList() => FirebaseFirestore.instance
      .collection('PromotionList')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // inspect(doc.data());
            log(doc.id);

            return Promotion.fromJson(doc.data());
          }).toList());
}

class Promotion {
  final String id;
  final String title;
  final String subtitle;
  final String imageurl;

  Promotion(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.imageurl});

  static Promotion fromJson(Map<String, dynamic> json) => Promotion(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageurl: json['imageurl']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'imageurl': imageurl,
      };
}
