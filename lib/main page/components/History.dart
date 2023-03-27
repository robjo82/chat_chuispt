import '../../database_service.dart';
import '../../main.dart';
import '../../constants.dart';

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../response.dart';

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
