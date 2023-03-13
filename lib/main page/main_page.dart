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
  String userPost = '';

  @override
  Widget build(BuildContext context) {
    // * Variables :
    var appState = context.watch<MainAppState>(); // état de l'application
    MyTextField textField = const MyTextField(); // le champ de texte
    LeftBar leftBar = const LeftBar(); // la barre de gauche

    return Consumer<MainAppState>(builder: (context, value, child) {
      return Scaffold(
        body: Row(
          children: [
            leftBar,
            if (appState.questionsList.isEmpty)
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
                      const Expanded(child: QuestionGrid()),
                      Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25, top: 25, right: 15, left: 15),
                          child: textField),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  color: themeApp.colorScheme.background,
                  child: Column(children: [
                    const SizedBox(height: 75),
                    Text('Chat ChuisPT', style: titleText),
                    const SizedBox(height: 25),
                    const Flexible(child: History()),
                    Padding(
                        padding: const EdgeInsets.all(20), child: textField),
                  ]),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class LeftBar extends StatefulWidget {
  const LeftBar({Key? key}) : super(key: key);

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: themeApp.colorScheme.surface,
        width: 75,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 75)),
            IconButton(
                iconSize: 35,
                color: themeApp.colorScheme.onPrimaryContainer,
                onPressed: () {
                  setState(() {
                    context.read<MainAppState>().clearQuestionList();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ));
  }
}
