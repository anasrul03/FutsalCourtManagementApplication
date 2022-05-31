import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/selectcourtpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late String direct;
String title = '';
String imageurl = '';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  final user = FirebaseAuth.instance.currentUser!;
  double height = 72, width = 110;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<List<Favorite>>(
        stream: getFavoriteList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error} ");
          } else if (snapshot.hasData) {
            final favoriteList = snapshot.data!;

            return ListView(
              children: favoriteList.map(buildList).toList(),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget buildList(Favorite favoriteList) => GestureDetector(
      //when clicked it will directed based on database
      onTap: () async {
        // Obtain shared preferences.
        // final prefs = await SharedPreferences.getInstance();
        // // Save an String value to 'action' key.
        // await prefs.setString('futsalId', futsal.id);

        setState(() {
          //Setting the variable that can change direction court list
          direct = "FutsalList/${favoriteList.futsalId}/Courts";
          title = favoriteList.address;
          imageurl = favoriteList.imageURL;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectCourt(
                  futsalIdFav: favoriteList.futsalId,
                  futsalAddress: favoriteList.address,
                  futsalTitle: favoriteList.futsalTitle)),
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
                    title: Text(favoriteList.futsalTitle,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(favoriteList.address,
                        style: TextStyle(color: Colors.white60, fontSize: 10)),
                    trailing: IconButton(
                      onPressed: () {
                        print("Button DElete CLicked");
                        final favDoc = FirebaseFirestore.instance
                            .collection("UserData")
                            .doc(user.email)
                            .collection("Favorite")
                            .doc(favoriteList.futsalId);

                        print(favoriteList.futsalId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.grey,
                          content: Text("Removed from favorite"),
                          duration: Duration(milliseconds: 100),
                        ));
                        favDoc.delete();
                      },
                      icon:
                          Icon(Icons.delete_forever_sharp, color: Colors.white),
                    ))),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                  child: Image.network(
                    favoriteList.imageURL,
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
  Stream<List<Favorite>> getFavoriteList() => FirebaseFirestore.instance
      .collection('UserData')
      .doc(user.email)
      .collection("Favorite")
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // log(doc.id);
            // log('called getBookedList ');
            return Favorite.fromJson(doc.data());
          }).toList());
}

class Favorite {
  final String directory;
  final String futsalId;
  final String userId;
  final String imageURL;
  final String address;
  final String futsalTitle;

  Favorite({
    required this.futsalTitle,
    required this.directory,
    required this.futsalId,
    required this.userId,
    required this.imageURL,
    required this.address,
  });

  static Favorite fromJson(Map<String, dynamic> json) => Favorite(
        directory: json['directory'],
        futsalId: json['futsalId'],
        userId: json['userId'],
        imageURL: json['imageURL'],
        address: json['address'],
        futsalTitle: json['futsalTitle'],
      );
}
