import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'main_page.dart';
import 'textstyle.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  var selectedIndex = 1;

  // store the user's question
  final _textController = TextEditingController();
  String userPost = '';

  @override
  Widget build(BuildContext context) {
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
