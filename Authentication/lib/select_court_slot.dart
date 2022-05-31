// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_futsal_reference.dart' as futsalReference;
import 'all_court_reference.dart' as courtReference;

import 'components/gridview_slot.dart';


class CourtSlot extends StatefulWidget {
  const CourtSlot({Key? key}) : super(key: key);

  @override
  State<CourtSlot> createState() => _CourtSlotState();
}

class _CourtSlotState extends State<CourtSlot> {
  DatePickerController _controller = DatePickerController();

  DateTime selectedValue = DateTime.now();
  // Color unselectedColor = Colors.white;
  Color selectedColor = Colors.blue;
  static const TextStyle unsselectedColor = TextStyle(color: Colors.white);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text("Select Your Slot", style: GoogleFonts.lato()),
        ),
        body: Container(
            child: Column(children: [
          Container(
            color: Colors.black,
            height: 230,
            child: Stack(
              textDirection: TextDirection.ltr,
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(Rect.fromLTRB(0, 0, rect.width, 190));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(futsalReference.imageurl,
                      fit: BoxFit.fill, height: 200, width: double.infinity),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      SizedBox(height: 50),
                      Center(
                        child: Column(
                          children: [
                            Text(futsalReference.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600,
                                )),
                            SizedBox(height: 7),
                            Text(
                                "Your have choose Court " +
                                    courtReference.courtTitle,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w300,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      DatePicker(
                        DateTime.now(),
                        width: 60,
                        height: 80,
                        daysCount: 60,
                        controller: _controller,
                        dateTextStyle: unsselectedColor,
                        dayTextStyle: unsselectedColor,
                        monthTextStyle: unsselectedColor,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: selectedColor,
                        selectedTextColor: Colors.white,
                        
                        //closed day
                        // inactiveDates: [
                        //   DateTime.now().add(Duration(days: 3)),
                        //   DateTime.now().add(Duration(days: 4)),
                        //   DateTime.now().add(Duration(days: 7))
                        // ],
                        onDateChange: (date) {
                          // New date selected
                          setState(() {
                            selectedValue = date;
                          });
                        },
                      ),
                      SizedBox(height: 6),
                      Center(
                        child: Text("Available Slots",
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SlotGrid(
            selectedDate: selectedValue,
          )
        ])));
  }
}
