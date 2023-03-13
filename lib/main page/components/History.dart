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
                  // * REPONSES * //
                  color: themeApp.colorScheme.secondaryContainer,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    reponseList[Random().nextInt(reponseList.length)],
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
  }
}
