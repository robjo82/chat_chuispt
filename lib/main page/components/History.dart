import '../../main.dart';
import '../../constants.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _key = GlobalKey();
  List<String> reponseList = [
    'oui',
    'non',
    'peut-être',
    'je ne sais pas',
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    appState.historyKey = _key;

    return ListView.builder(
      reverse: true,
      itemCount: appState.questionsList.length,
      itemBuilder: (context, index) {
        final question = appState.questionsList[index];
        return Center(
          child: Column(
            children: [
              // space between 2 [questions/responses]
              const SizedBox(height: 0),

              // * QUESTION * //
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: themeApp.colorScheme.primaryContainer,
                      // space of the question container
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        question,
                        style: normalText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              // * REPONSES * //
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: themeApp.colorScheme.secondaryContainer,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        reponseList[Random().nextInt(reponseList.length)],
                        style: normalText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_up,
                              size: 18,
                              color: themeApp.colorScheme.onPrimaryContainer,
                            )),
                        const SizedBox(
                            width:
                                10), // Ajoutez un espace entre les deux icônes
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_down,
                              size: 18,
                              color: themeApp.colorScheme.onPrimaryContainer,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
