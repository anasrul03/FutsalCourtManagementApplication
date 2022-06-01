import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/round_button.dart';
import 'components/utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String _mailLambung = '';
  @override
  void dispose() {
    emailController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 900,
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
            padding: const EdgeInsets.all(16),
            child: Form(
                key: formKey,
                child: Center(
                  heightFactor: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: Column(
                      children: [
                        Image.asset(
                          "lib/assets/images/logo.png",
                          width: 150,
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Input your email to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "We will send you a link to reset your password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 20),
                        Material(
                          elevation: 10.0,
                          borderRadius: BorderRadius.circular(30.0),
                          shadowColor: Color(0x55434343),
                          child: TextFormField(
                            onChanged: (value) {
                              _mailLambung = value;
                              log(_mailLambung);
                            },
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Enter a valid email!'
                                    : null,
                          ),
                        ),
                        RoundedButton(
                            text: "Reset Password",
                            press: () => resetPassword(_mailLambung)),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  Future<void> resetPassword(email) async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(child: CircularProgressIndicator()));
    try {
      var resetResponse =
          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      var snackBar = SnackBar(
        content: Text('email sent to $email'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      log(e.toString());
    }

    // try {
    //   print("password reset sent");
    //   await FirebaseAuth.instance
    //       .sendPasswordResetEmail(email: emailController.text.trim());
    //   print(emailController.text.trim());
    //   // Utils.showSnackBar("Password Reset sent to your email");
    //   // Navigator.of(context).popUntil((route) => route.isFirst);
    // } on FirebaseAuthException catch (e) {
    //   // Utils.showSnackBar(e.message);
    //   print(e);
    //   // Navigator.of(context).pop();
    // }
  }
}
