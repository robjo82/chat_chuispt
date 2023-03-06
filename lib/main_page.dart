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
      return Column(children: [
        const SizedBox(height: 100),
        Text('Chat ChuisPT', style: titleText),
        const SizedBox(height: 5),
        Text('Exemples de questions...', style: titleText2),
        const SizedBox(height: 5),
        Flexible(child: QuestionGrid()),
        const Flexible(child: History()),
        Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 75),
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
              padding: const EdgeInsets.only(bottom: 75),
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
    for (int i = 1; i <= 8; i++) {
      questions.add(
        Container(
            color: Colors.grey[300],
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                exemples[Random().nextInt(exemples.length)],
              ),
            )),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.favorite),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.home),
              ),
            ),
            Center(
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.work),
              ),
            ),
          ],
        ),
        Expanded(
          child: GridView.count(
            primary: false,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
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
