import 'package:chat_application/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'api/firebase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "chat application",
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 63, 17, 177)),
      ),
      home: Scaffold(body: AuthScreen()),
    );
  }
}
