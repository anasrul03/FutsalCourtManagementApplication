import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class DataController extends GetxController {
//   Future getData() async {
//     final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     QuerySnapshot snapshot =
//         await firebaseFirestore.collection(collection).get();

//     return snapshot.docs;
//   }

//   Future queryData(String queryString) async {
//     return FirebaseFirestore.instance
//         .collection("FutsalList")
//         .where('futsalTitle', isGreaterThanOrEqualTo: queryString)
//         .get();
//   }
// }
