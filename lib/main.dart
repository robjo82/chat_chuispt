import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  void writeData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("questions/2");

    await ref.set({
      "blue_thumb": 0,
      "id": 2,
      "red_thumb": 0,
      "text": "Mon comptable rêve de bible et de gros chiffres."
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child:
              TextButton(onPressed: writeData, child: const Text("Write data")),
        ),
      ),
    );
  }
}
