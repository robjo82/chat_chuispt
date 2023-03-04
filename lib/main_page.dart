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

    return Column(children: [
      const SizedBox(height: 100),
      Text('Chat ChuisPT', style: titleText),
      const SizedBox(height: 5),
      Text('Exemples de questions...', style: titleText2),
      const SizedBox(height: 5),
      Flexible(child: QuestionGrid()),
      Center(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 75),
        child: TextField(
          textAlign: TextAlign.center,
          controller: _textController,
          style: normalText,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Posez votre question ici...',
              suffixIcon: IconButton(
                  onPressed: () {
                    //appState.Send(_textController);
                    _textController.clear();
                  },
                  icon: const Icon(Icons.send))),
        ),
      )),
      Text(userPost, style: titleText2),
    ]);
  }
}

class QuestionGrid extends StatelessWidget {
  QuestionGrid({Key? key}) : super(key: key);

  List<String> exemples = [
    "Qu'est-ce que le Covid-19 ?",
    "Quels sont les symptômes du Covid-19 ?",
    "Comment se transmet le Covid-19 ?",
    "Quels sont les risques de contamination ?",
    "Quel est la taille moyenne d'une famille ?",
    "Quel est l'^age moyen d'un crabe ?",
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
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            crossAxisCount: 2,
            children: questions,
          ),
        ),
      ],
    );
  }

  void onPressed() {}
}
