import 'package:chat_chuispt/question2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(MainApp());
  } catch (e) {
    print(e);
  }
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final stream = DatabaseService().getTexts();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(child: TextListWidget(stream: stream)),
    ));
  }
}
