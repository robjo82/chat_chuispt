import 'package:chat_chuispt/src/repositories/database/database_repository.dart';
import 'package:chat_chuispt/main.dart';
import 'package:chat_chuispt/assets/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_chuispt/src/models/responses.dart';

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

        final responseList = snapshot.data ?? [];
        final LocalResponseList localResponseList = LocalResponseList();
        localResponseList.addResponseListFromMap(responseList);

        return ListView.builder(
          reverse: true,
          itemCount: appState.questionsList.length,
          itemBuilder: (context, index) {
            final question = appState.questionsList[index];
            if (index >= selectedResponses.length) {
              selectedResponses.insert(
                  0, localResponseList.getRandomResponseWithWeights());
            }
            final randomResponse = selectedResponses[index];

            void likeResponse() {
              setState(() {
                if (!selectedResponses[index].isLiked) {
                  if (!selectedResponses[index].isDisliked) {
                    selectedResponses[index].isLiked = true;
                    _databaseService.vote(
                        selectedResponses[index].id, "unvoted", "blue");
                  } else {
                    selectedResponses[index].isLiked = true;
                    selectedResponses[index].isDisliked = false;
                    _databaseService.vote(
                        selectedResponses[index].id, "red", "blue");
                  }
                } else {
                  selectedResponses[index].isLiked = false;
                  _databaseService.vote(
                      selectedResponses[index].id, "blue", "unvoted");
                }
              });
            }

            void dislikeResponse() {
              setState(() {
                if (!selectedResponses[index].isDisliked) {
                  if (!selectedResponses[index].isLiked) {
                    selectedResponses[index].isDisliked = true;
                    _databaseService.vote(
                        selectedResponses[index].id, "unvoted", "red");
                  } else {
                    selectedResponses[index].isDisliked = true;
                    selectedResponses[index].isLiked = false;
                    _databaseService.vote(
                        selectedResponses[index].id, "blue", "red");
                  }
                } else {
                  selectedResponses[index].isDisliked = false;
                  _databaseService.vote(
                      selectedResponses[index].id, "red", "unvoted");
                }
              });
            }

            // * Thumb icons
            IconData myThumbUp;
            myThumbUp = selectedResponses[index].isLiked
                ? Icons.thumb_up
                : Icons.thumb_up_outlined;

            IconData myThumbDown;
            myThumbDown = selectedResponses[index].isDisliked
                ? Icons.thumb_down
                : Icons.thumb_down_outlined;

            return Column(children: [
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
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      color: themeApp.colorScheme.primary,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    likeResponse();
                                  },
                                  icon: Icon(
                                    myThumbUp,
                                    size: 18,
                                    color:
                                        themeApp.colorScheme.onPrimaryContainer,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    dislikeResponse();
                                  },
                                  icon: Icon(
                                    myThumbDown,
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
            ]);
          },
        );
      },
    );
  }
}
