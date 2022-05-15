// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/components/round_button.dart';
import 'main.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black,
              Colors.purple,
            ],
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          //Card is over here!
          child: Card(
            elevation: 30.0,
            shadowColor: Color(0x55434343),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "lib/assets/images/logo.png",
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 40),
                    Text(
                      "Welcome to Courtify",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Login to book your game!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 40),
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Color(0x55434343),
                      child: TextField(
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
                      ),
                    ),
                    SizedBox(height: 4),
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(30.0),
                      shadowColor: Color(0x55434343),
                      child: TextField(
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
                      ),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(text: "Submit", press: signIn),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                          text: "No Account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.onClickedSignUp,
                                text: 'Sign Up',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary))
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }

//text
  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
