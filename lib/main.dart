import 'package:chat_chuispt/show_features_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chat_chuispt/database_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(MainApp());
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stream = DatabaseService().getData();

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: DataListWidget(stream: stream),
            ),
            const AddQuestionWidget(),
          ],
        ),
      ),
    );
  }
}
