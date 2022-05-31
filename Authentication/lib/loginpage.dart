// ignore_for_file: prefer_const_constructors

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:login_attemp2/components/round_button.dart';
import 'main.dart';
import '../dashboard.dart' as PageIndex;

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
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
        color: Color.fromARGB(255, 47, 47, 47),
        child: Center(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 19, horizontal: 10),
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
                    Colors.blueGrey,
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
                    SizedBox(height: 20),
                    Text(
                      "Welcome to Courtify",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Login to book your game",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 20),
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
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
                      borderRadius: BorderRadius.circular(15.0),
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
                      ),
                    ),
                    SizedBox(height: 20),
                    RoundedButton(text: "Log in", press: signIn),
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
                                    color: Colors.blue[200]))
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
    setState(() {
      PageIndex.currentIndex = 0;
    });

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully Logged as " + emailController.text.trim()),
        duration: Duration(seconds: 1),
      ));
    } on FirebaseAuthException catch (e) {
      print("Wrong password");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Your input correct email and password !!"),
        duration: Duration(seconds: 3),
      ));
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
