// ignore_for_file: prefer_const_constructors
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

import 'components/gridview_slot.dart';

class CourtSlot extends StatefulWidget {
  const CourtSlot({Key? key}) : super(key: key);

  @override
  State<CourtSlot> createState() => _CourtSlotState();
}

class _CourtSlotState extends State<CourtSlot> {
  DatePickerController _controller = DatePickerController();

  DateTime selectedValue = DateTime.now();
  Color unselectedColor = Colors.white;
  Color selectedColr = Colors.blue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Your Slot"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.blueGrey[100],
            child: Column(
              children: <Widget>[
                Container(
                  //Here is the main
                  child: DatePicker(
                    DateTime.now(),
                    width: 60,
                    height: 80,
                    controller: _controller,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.blue,
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
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Text("You Selected:"),
                Text(selectedValue.toString()),
                Padding(
                  padding: EdgeInsets.all(20),
                ),
                Text("Available Slots"),
                SlotGrid(
                  selectedDate: selectedValue,
                )
              ],
            ),
          ),
        ));
  }
}


