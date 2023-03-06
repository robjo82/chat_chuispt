import 'dart:math';
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
  var selectedIndex = 0;

  // store the user's question
  final _textController = TextEditingController();
  String userPost = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    // ! LISTE VIDE ! //
    if (appState.responsesList.isEmpty) {
      return Consumer<MainAppState>(builder: (context, value, child) {
        return Container(
          color: themeApp.colorScheme.background,
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text('Chat ChuisPT', style: titleText),
              const SizedBox(height: 5),
              Text('Exemples de questions...', style: titleText2),
              const SizedBox(height: 5),
              Expanded(child: QuestionGrid()),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 25, top: 25, right: 15, left: 15),
                    child: TextField(
                      controller: _textController,
                      style: normalText,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Posez votre question ici...',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  userPost = _textController.text;
                                  context
                                      .read<MainAppState>()
                                      .addQuestion(userPost);
                                  _textController.clear();
                                });
                              },
                              icon: const Icon(Icons.send))),
                    ),
                  )),
            ],
          ),
        );
      });
    }

    // ! LISTE NON VIDE ! //
    else {
      return Column(children: [
        const SizedBox(height: 100),
        Text('Chat ChuisPT', style: titleText),
        const SizedBox(height: 25),
        Text('Exemples de questions...', style: titleText2),
        const SizedBox(height: 50),
        const Flexible(child: History()),
        Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _textController,
                style: normalText,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Posez votre question ici...',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            userPost = _textController.text;
                            context.read<MainAppState>().addQuestion(userPost);
                            _textController.clear();
                          });
                        },
                        icon: const Icon(Icons.send))),
              ),
            )),
      ]);
    }
  }
}

class QuestionGrid extends StatelessWidget {
  QuestionGrid({Key? key}) : super(key: key);

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

    // * Génération du tableau aléatoire de questions * //
    for (int i = 1; i <= 4; i++) {
      questions.add(
        Container(
            color: Colors.grey[300],
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                exemples[Random().nextInt(exemples.length)],
                textAlign: TextAlign.center,
              ),
            )),
      );
    }

    // ! AFFICHAGE ! //
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 10, top: 10),
              child: Center(
                child: Icon(
                  Icons.home,
                  color: themeApp.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 10, top: 10),
              child: Center(
                child: Icon(
                  Icons.home,
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

  void onPressed() {}
}

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _key = GlobalKey();
  List<String> reponseList = ['oui', 'non', 'peut-être', 'je ne sais pas'];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    appState.historyKey = _key;

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
                const SizedBox(height: 20),
                Text(question, style: titleText2),
                const SizedBox(height: 20),
                Text(reponseList[Random().nextInt(reponseList.length)],
                    style: titleText2.copyWith(color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}
