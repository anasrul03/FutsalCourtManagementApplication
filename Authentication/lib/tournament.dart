import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TournamentList extends StatefulWidget {
  const TournamentList({Key? key}) : super(key: key);

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text("UNDER MAINTAINANCE",
              style: TextStyle(
                fontSize: 40,
              ))),
    );
  }

  Widget buildInfo(userInfo userinfo) => Column(
        children: [
          Text(userinfo.email),
          SizedBox(height: 50),
          Text(userinfo.phoneNumber),
          SizedBox(height: 50),
          Text(userinfo.nickname),
          SizedBox(height: 50),
          Text(userinfo.userId)
        ],
      );
  Stream<List<userInfo>> getUserInfo() => FirebaseFirestore.instance
      .collection('UserData')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            // inspect(doc.data());
            // log(doc.id);

            return userInfo.fromJson(doc.data());
          }).toList());
}

class userInfo {
  final String email;
  final String phoneNumber;
  final String nickname;
  final String userId;

  userInfo(
      {required this.email,
      required this.phoneNumber,
      required this.nickname,
      required this.userId});

  static userInfo fromJson(Map<String, dynamic> json) => userInfo(
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        nickname: json['nickname'],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['nickname'] = this.nickname;
    data['userId'] = this.userId;
    return data;
  }
}
