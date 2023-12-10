import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Logged in !!!'),
          ElevatedButton(
              onPressed: FirebaseAuth.instance.signOut,
              child: const Text('Logout'))
        ],
      ),
    ));
  }
}
