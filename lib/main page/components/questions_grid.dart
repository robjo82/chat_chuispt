import '../../main.dart';
import '../../constants.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionGrid extends StatefulWidget {
  const QuestionGrid({Key? key}) : super(key: key);

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
            decoration: BoxDecoration(
                color: themeApp.colorScheme.secondaryContainer.withOpacity(1),
                borderRadius: BorderRadius.circular(10)),
            child: TextButton(
              onPressed: () {
                setState(() {
                  userQuestion = exemples[Random().nextInt(exemples.length)];
                  context.read<MainAppState>().addQuestion(userQuestion);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  style: normalText,
                  exemples[Random().nextInt(exemples.length)],
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      );
    }

    // Display
    return Column(
      children: [
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(
                Icons.help_center_outlined,
                color: themeApp.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 155),
            Center(
              child: Icon(
                Icons.question_answer,
                color: themeApp.colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            primary: false,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 2,
            children: questions,
          ),
        ),
      ],
    );
  }
}
