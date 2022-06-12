import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/paymentpage.dart';

import 'constants/DateParsers.dart';

class PaymentTotal extends StatefulWidget {
  final DateTime? selectedDate;
  final String futsalTitle;
  final String courtName;
  final String courtType;
  final int pricePerHour;

  const PaymentTotal(
      {Key? key,
      required this.futsalTitle,
      required this.pricePerHour,
      required this.selectedDate,
      required this.courtName,
      required this.courtType})
      : super(key: key);

  @override
  State<PaymentTotal> createState() => _PaymentTotalState();
}

class _PaymentTotalState extends State<PaymentTotal> {
  String? _courtPrice = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text("Booking Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
                child: Column(
              children: [
                Text("Futsal", style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.futsalTitle,
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                Text("Court", style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 10,
                ),
                Text("Court ${widget.courtName} (${widget.courtType}) ",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                Text("Slot Date and Time",
                    style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 10,
                ),
                Text(widget.selectedDate.toString(),
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                Text("Total Payment", style: TextStyle(color: Colors.white60)),
                SizedBox(
                  height: 10,
                ),
                Text("RM ${widget.pricePerHour}",
                    style: TextStyle(fontSize: 30, color: Colors.white)),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentCardPage(
                                        getData: widget.selectedDate,
                                        priceTotal: widget.pricePerHour,
                                      )));
                          print(widget.selectedDate);
                        },
                        child: Text("Deposit Payment")),
                    SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentCardPage(
                                        getData: widget.selectedDate,
                                        priceTotal: widget.pricePerHour,
                                      )));
                        },
                        child: Text("Full Payment"))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                      "We only accept payment using credit card or debit card, Cash only accept for further payment at our counter if you only made a deposit payment.",
                      style: TextStyle(color: Colors.white60)),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
