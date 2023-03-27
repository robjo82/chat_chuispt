import 'dart:ffi';

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
    double largeurEcran = MediaQuery.of(context).size.width;

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
                      color: themeApp.colorScheme.secondary,
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: themeApp.colorScheme.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          // * Response
                          Text(
                            reponseList[Random().nextInt(reponseList.length)],
                            style: normalText,
                            textAlign: TextAlign.center,
                          ),

                          // * Thumbs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.thumb_up,
                                    size: 18,
                                    color:
                                        themeApp.colorScheme.onPrimaryContainer,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.thumb_down,
                                    size: 18,
                                    color:
                                        themeApp.colorScheme.onPrimaryContainer,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
