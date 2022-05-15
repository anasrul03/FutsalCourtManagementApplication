import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


//DUMMY PAGE
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text("HOMEPAGE"),
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In as",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              user.email!,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.arrow_back),
              label: Text("Sign Out"),
            )
          ],
        ),
      ),
    );
  }
}
