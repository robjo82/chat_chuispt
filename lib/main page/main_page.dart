import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../main.dart';

import 'components/History.dart';
import 'components/QuestionsGrid.dart';
import 'components/TextField.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // store the user's question
  String userQuestion = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    MyTextField textField = const MyTextField();

    // Empty list case
    return Consumer<MainAppState>(builder: (context, value, child) {
      return Scaffold(
        body: appState.questionsList.isEmpty
            ? Row(
                children: [
                  Container(
                      color: themeApp.colorScheme.primaryContainer,
                      width: 75,
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 75)),
                          IconButton(
                              iconSize: 35,
                              color: themeApp.colorScheme.onPrimaryContainer,
                              onPressed: () {
                                setState(() {
                                  context
                                      .read<MainAppState>()
                                      .clearQuestionList();
                                });
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      )),
                  Expanded(
                    child: Container(
                      color: themeApp.colorScheme.background,
                      child: Column(
                        children: [
                          const SizedBox(height: 75),
                          Text('Chat ChuisPT', style: titleText),
                          const SizedBox(height: 5),
                          Text('Exemples de questions...', style: titleText2),
                          const SizedBox(height: 5),
                          Expanded(child: QuestionGrid()),
                          Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 25, top: 25, right: 15, left: 15),
                              child: textField),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            :

            // Non-empty list case
            Row(
                children: [
                  Container(
                      color: themeApp.colorScheme.primaryContainer,
                      width: 75,
                      child: Column(
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 75)),
                          IconButton(
                              iconSize: 35,
                              color: themeApp.colorScheme.onPrimaryContainer,
                              onPressed: () {
                                setState(() {
                                  context
                                      .read<MainAppState>()
                                      .clearQuestionList();
                                });
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      )),
                  Expanded(
                    child: Container(
                      color: themeApp.colorScheme.background,
                      child: Column(children: [
                        const SizedBox(height: 75),
                        Text('Chat ChuisPT', style: titleText),
                        const SizedBox(height: 25),
                        const Flexible(child: History()),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: textField),
                      ]),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
