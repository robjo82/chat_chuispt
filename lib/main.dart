import 'package:chat_chuispt/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'main page/main_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    print("Firebase initializing...");
  }

  // Vérifie si l'application Firebase par défaut est déjà initialisée
  FirebaseApp? app;
  try {
    app = Firebase.app();
  } catch (e) {
    if (kDebugMode) {
      print("No default Firebase app found. Initializing...");
    }
  }

  if (app == null) {
    // Initialise l'application Firebase si elle n'est pas déjà initialisée
    try {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainAppState(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false, //debug banner desactivation
          title: 'Chat ChuisPt',
          theme: themeApp,
          home: const MainPage()),
    );
  }
}

class MainAppState extends ChangeNotifier {
  List<String> questionsList = [];
  List<String> responsesList = [];
  var historyKey = GlobalKey();

  // Adds a question to the list and updates the UI
  void addQuestion(String question) {
    if (question != '') {
      questionsList.insert(0, question);
      notifyListeners();
      var animatedList = historyKey.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
    }
  }

  // Clears the question list
  void clearQuestionList() {
    questionsList.clear();
    notifyListeners();
  }
}
