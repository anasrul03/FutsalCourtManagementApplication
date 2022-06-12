// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard.dart' as PageIndex;

import 'components/round_button.dart';
import 'main.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final nicknameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Sign up page");
    return Container(
      height: 1000,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.black,
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: 60),
            Image.asset(
              "lib/assets/images/logo.png",
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              "Sign Up your account",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextFormField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email!'
                        : null,
              ),
            ),
            SizedBox(height: 4),
            Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextFormField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                controller: nicknameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Nickname",
                  prefixIcon: Icon(
                    Icons.title,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (nickname) { if (nickname == null || nickname.isEmpty) {
                      return "Please enter Nickname";
                    } else {
                      return null;
                    }},
              ),
            ),
            SizedBox(height: 4),
            Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  controller: phoneNumberController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black54,
                    ),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Phone Number";
                    } else {
                      return null;
                    }
                  }),
            ),
            SizedBox(height: 4),
            Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(30.0),
              shadowColor: Color(0x55434343),
              child: TextFormField(
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  border: InputBorder.none,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter minimum 6 characters'
                    : null,
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(text: "Sign Up", press: signUp),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: "Already have an account? ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Log in',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.secondary))
                  ]),
            )
          ]),
        ),
      ),
    );
  }

  Future signUp() async {
    setState(() {
      PageIndex.currentIndex = 0;
    });

    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      final user = FirebaseAuth.instance.currentUser!;

      FirebaseFirestore.instance
          .collection('UserData')
          .doc(emailController.text.trim())
          .set({
        "email": emailController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "nickname": nicknameController.text.trim(),
        "userId": user.uid,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully registered"),
        duration: Duration(milliseconds: 300),
      ));
    } on FirebaseAuthException catch (e) {
      print(e);
      // print("already registered");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Your email already registered !!"),
        duration: Duration(seconds: 3),
      ));
    }

    // Navigator.of(context) not working!
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
