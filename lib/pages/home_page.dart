import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petpals/auth/auth.dart';
import 'package:petpals/service/auth_service.dart'; // Import your AuthService

class HomePage extends StatelessWidget {
  final BuildContext context; // Accept context here

  HomePage({required this.context, super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    AuthService().signOut(); // Call signOut() method from AuthService
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "LOGGED IN AS: " + user.email!,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
