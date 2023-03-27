import '../../main.dart';
import '../../constants.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
