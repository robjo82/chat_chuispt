import 'dart:math';
import 'package:chat_chuispt/database_service.dart';
import 'package:chat_chuispt/response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'textstyle.dart';
import 'main.dart';

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

class MyTextField extends StatefulWidget {
  const MyTextField({Key? key}) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _textController = TextEditingController();
  String userQuestion = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: true,
      controller: _textController,
      style: normalText,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Posez votre question ici...',
          labelStyle: normalText,
          suffixIcon: IconButton(
              color: themeApp.colorScheme.onPrimary,
              onPressed: () {
                setState(() {
                  userQuestion = _textController.text;
                  context.read<MainAppState>().addQuestion(userQuestion);
                  _textController.clear();
                });
              },
              icon: const Icon(Icons.send))),
    );
  }
}

class QuestionGrid extends StatefulWidget {
  QuestionGrid({Key? key}) : super(key: key);

  @override
  State<QuestionGrid> createState() => _QuestionGridState();
}

class _QuestionGridState extends State<QuestionGrid> {
  final List<String> exemples = [
    "Qu'est-ce que le Covid-19 ?",
    "Quels sont les symptômes du Covid-19 ?",
    "Comment se transmet le Covid-19 ?",
    "Quels sont les risques de contamination ?",
    "Quel est la taille moyenne d'une famille ?",
    "Quel est l'âge moyen d'un crabe ?",
    "Quel est le nombre de personnes qui ont été contaminées ?",
    "Pourquoi 42 ?",
    "Quand est-ce que le monde va mourir ?",
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> questions = [];

    // Generate a random array of questions
    String userQuestion = "";
    for (int i = 1; i <= 4; i++) {
      questions.add(
        Container(
            color: Colors.grey[300],
            child: TextButton(
              onPressed: () {
                setState(() {
                  userQuestion = exemples[Random().nextInt(exemples.length)];
                  context.read<MainAppState>().addQuestion(userQuestion);
                });
              },
              child: Text(
                exemples[Random().nextInt(exemples.length)],
                textAlign: TextAlign.center,
              ),
            )),
      );
    }

    // Display
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 10, top: 10),
              child: Center(
                child: Icon(
                  Icons.help_center_outlined,
                  color: themeApp.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
              child: Center(
                child: Icon(
                  Icons.question_answer,
                  color: themeApp.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.only(right: 20, left: 20),
            primary: false,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: questions,
          ),
        ),
      ],
    );
  }
}

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _key = GlobalKey();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    appState.historyKey = _key;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _databaseService.getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error has occurred'));
        }

        final reponseList = snapshot.data ?? [];
        final LocalResponseList localResponseList = LocalResponseList();
        localResponseList.addResponseListFromMap(reponseList);

        return AnimatedList(
          key: _key,
          reverse: true,
          initialItemCount: appState.questionsList.length,
          itemBuilder: (context, index, animation) {
            final question = appState.questionsList[index];
            return SizeTransition(
              sizeFactor: animation,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                        // * QUESTION * //
                        color: themeApp.colorScheme.primaryContainer,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          question,
                          style: titleText2,
                          textAlign: TextAlign.center,
                        )),
                    const SizedBox(height: 10),
                    Container(
                      // * RESPONSES * //
                      color: themeApp.colorScheme.secondaryContainer,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        localResponseList.getRandomResponseWithWeights().text,
                        style: titleText2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
