import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_attemp2/components/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard.dart';

class SlotGrid extends StatefulWidget {
  final DateTime? selectedDate;

//   SlotGrid({Key? key, required this.selectedDate}) : super(key: key);

  const SlotGrid({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<SlotGrid> createState() => _SlotGridState();
}

class _SlotGridState extends State<SlotGrid> {
  Color unselectedColor = Colors.white;
  Color selectedColor = Colors.blue;
  int selectedCard = -1;

  late String time;
  late DateTime startDateTime;

  static DateTime now = DateTime.now();

  List<DateTime?> SlotTime = [
    DateTime(now.year, now.month, now.day, 0),
    DateTime(now.year, now.month, now.day, 1),
    DateTime(now.year, now.month, now.day, 2),
    DateTime(now.year, now.month, now.day, 3),
    DateTime(now.year, now.month, now.day, 4),
    DateTime(now.year, now.month, now.day, 5),
    DateTime(now.year, now.month, now.day, 6),
    DateTime(now.year, now.month, now.day, 7),
    DateTime(now.year, now.month, now.day, 8),
    DateTime(now.year, now.month, now.day, 9),
    DateTime(now.year, now.month, now.day, 10),
    DateTime(now.year, now.month, now.day, 11),
    DateTime(now.year, now.month, now.day, 12),
    DateTime(now.year, now.month, now.day, 13),
    DateTime(now.year, now.month, now.day, 14),
    DateTime(now.year, now.month, now.day, 15),
    DateTime(now.year, now.month, now.day, 16),
    DateTime(now.year, now.month, now.day, 17),
    DateTime(now.year, now.month, now.day, 18),
    DateTime(now.year, now.month, now.day, 19),
    DateTime(now.year, now.month, now.day, 20),
    DateTime(now.year, now.month, now.day, 21),
    DateTime(now.year, now.month, now.day, 22),
    DateTime(now.year, now.month, now.day, 23),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600,
          width: double.infinity,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: 24,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  color: selectedCard == index ? Colors.blue : Colors.white,
                  child: Center(child: Text(dateTimeToHours(SlotTime[index]))),
                ),
                onTap: () {
                  setState(() {
                    // ontap of each card, set the defined int to the grid view index
                    selectedCard = index;
                  });
                  startDateTime = DateTime(
                      widget.selectedDate!.year,
                      widget.selectedDate!.month,
                      widget.selectedDate!.day,
                      SlotTime[index]!.hour,
                      SlotTime[index]!.minute);
                },
              );
            },
          ),
        ),
        SizedBox(height: 10),
        TextButton(
            child: Text("text"), onPressed: () => sendDateTime(startDateTime))
      ],
    );
  }

  String dateTimeToHours(DateTime? date) {
    return DateFormat.jm().format(date!);
  }

  sendDateTime(startDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'action' key. If it doesn't exist, returns null.

    var endDateTime = startDateTime.add(Duration(hours: 1));
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDateTime;
    data['endDate'] = endDateTime;
    data['userId'] = prefs.getString('userId');
    data['futsalId'] = prefs.getString('futsalId');
    data['courtId'] = prefs.getString('courtId');

    print(data);

    log(startDateTime.toString());
    inspect(data);
    try {
      final bookedDate = FirebaseFirestore.instance.collection('Booked').doc();
      await bookedDate.set(data);
      currentIndex = 2;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
  }
}
