import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_attemp2/userProfile_page.dart';

import 'dashboard.dart';
import 'main.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final nicknameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final double heightSpace = 10;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Courtify",
              style: GoogleFonts.lato(),
            ),
            SizedBox(width: 3),
            Icon(
              Icons.sports_soccer,
              color: Colors.blue,
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                Stack(
                  children: [
                    Card(
                      // elevation: 20.0,
                      // shadowColor: Color(0x55434343),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 190),
                              // ignore: prefer_const_constructors
                              Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: nicknameController,
                                        cursorColor: Colors.white,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: "Nickname",
                                          prefixIcon: Icon(
                                            Icons.title,
                                            color: Colors.black,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        // autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter nickname';
                                          }
                                        }),
                                    SizedBox(height: 10),
                                    TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        textAlign: TextAlign.start,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: phoneNumberController,
                                        cursorColor: Colors.white,
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          labelText: "Phone Number",
                                          prefixIcon: Icon(
                                            Icons.phone,
                                            color: Colors.black,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter number';
                                          }
                                        }),
                                  ],
                                ),
                              ),

                              SizedBox(height: heightSpace),
                              Card(
                                child: GestureDetector(
                                  onTap: () {
                                    updateData();
                                  },
                                  child: ListTile(
                                    tileColor: Colors.green,
                                    title: Center(
                                        child: Text('Update',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.8),
                      child: Stack(
                        children: [
                          ClipRRect(
                              child: Image.network(
                                "https://media.istockphoto.com/photos/abstract-background-color-gradient-light-blue-white-picture-id1269552168?k=20&m=1269552168&s=612x612&w=0&h=rFTFroan14_py5CI8ZWuZNFYXuvizmbLESMavGx2NnA=",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8))),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                    radius: 50,
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                    )),
                                SizedBox(height: 11),
                                // Text(user.uid, style: GoogleFonts.lato()),
                                Text(user.email!,
                                    style: GoogleFonts.lato(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                )
              ]))),
    );
  }

  Future updateData() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    final user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection("UserData").doc(user.email).update({
      'nickname': nicknameController.text.trim(),
      'phoneNumber': phoneNumberController.text.trim()
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text("updated"),
      duration: Duration(milliseconds: 200),
    ));
  }
}
