import 'dart:math';

import '../../database_service.dart';
import '../../main.dart';
import '../../constants.dart';

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
  List<LocalResponse> selectedResponses = [];

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

        return ListView.builder(
          reverse: true,
          itemCount: appState.questionsList.length,
          itemBuilder: (context, index) {
            final question = appState.questionsList[index];
            if (index >= selectedResponses.length) {
              selectedResponses.insert(
                  0, localResponseList.getRandomResponseWithWeights());
              print(selectedResponses);
            }
            final randomResponse = selectedResponses[index];
            return Center(
                child: Column(children: [
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
                            randomResponse.text,
                            style: normalText,
                            textAlign: TextAlign.center,
                          ),

                          // * Thumbs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _databaseService.updateBlueThumb(
                                        randomResponse.id,
                                        randomResponse.blueThumb + 1);
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    size: 18,
                                    color:
                                        themeApp.colorScheme.onPrimaryContainer,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _databaseService.updateRedThumb(
                                        randomResponse.id,
                                        randomResponse.redThumb + 1);
                                  },
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
            ]));
          },
        );
      },
    );
  }
}
