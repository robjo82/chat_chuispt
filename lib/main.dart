import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  void writeData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("questions/2");

    await ref.set({
      "blue_thumb": 0,
      "id": 2,
      "red_thumb": 0,
      "text": "Mon comptable rêve de bible et de gros chiffres."
    });
  }

  /// Get data from Firebase at questions/$id/text
  /// Return a Future<String>
  Future<Object?> getData(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("questions/$id/text");

    DatabaseEvent event = await ref.once();
    return event.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    int id = Random().nextInt(2);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: getData(id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
