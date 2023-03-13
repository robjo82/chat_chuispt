import 'package:chat_chuispt/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_page.dart';

void main() {
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

  void addQuestion(String question) {
    if (question != '') {
      questionsList.insert(0, question);
      notifyListeners();
      var animatedList = historyKey.currentState as AnimatedListState?;
      animatedList?.insertItem(0);
    }
  }

  void clearQuestionList() {
    questionsList.clear();
  }
}
