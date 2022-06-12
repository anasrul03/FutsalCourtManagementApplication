import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:login_attemp2/components/utils.dart';
import 'package:login_attemp2/paymentpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/DateParsers.dart';
import '../paymentTotal.dart';

class SlotGrid extends StatefulWidget {
  final DateTime? selectedDate;
  final String futsalTitle;
  final String courtName;
  final String courtType;
  final int pricePerHour;

//   SlotGrid({Key? key, required this.selectedDate}) : super(key: key);

  const SlotGrid(
      {Key? key,
      required this.selectedDate,
      required this.futsalTitle,
      required this.pricePerHour,
      required this.courtName,
      required this.courtType})
      : super(key: key);

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
          color: Colors.black,
          height: 360,
          width: double.infinity,
          child: SingleChildScrollView(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: SlotTime.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    color: selectedCard == index ? Colors.blue : Colors.white,
                    child:
                        Center(child: Text(dateTimeToHours(SlotTime[index]))),
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
        ),
        SizedBox(height: 30),
        Container(
            child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Payment(

              //             )));
              sendDateTime(startDateTime);
            },
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Proceed", style: GoogleFonts.lato(fontSize: 20))),
          ),
        )),
      ],
    );
  }

  String dateTimeToHours(DateTime? date) {
    return DateFormat.jm().format(date!);
  }

  sendDateTime(startDateTime) async {
    final prefs = await SharedPreferences.getInstance();
    var endDateTime = startDateTime.add(Duration(hours: 1));
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startDate'] = this.startDateTime;
    data['endDate'] = endDateTime;
    data['createdDate'] = DateTime.now().toString();
    data['userId'] = prefs.getString('userId');
    data['futsalId'] = prefs.getString('futsalId');
    data['courtId'] = prefs.getString('courtId');
    try {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentTotal(
                    futsalTitle: widget.futsalTitle,
                    pricePerHour: widget.pricePerHour,
                    selectedDate: startDateTime,
                    courtName: widget.courtName,
                    courtType: widget.courtType,
                  )));
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }
  }
}
