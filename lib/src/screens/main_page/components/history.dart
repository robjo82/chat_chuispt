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

class QuestionResponse {
  String question;
  LocalResponse response;

  QuestionResponse({required this.question, required this.response});
}

class _HistoryState extends State<History> {
  final _key = GlobalKey();
  final DatabaseService _databaseService = DatabaseService();
  List<QuestionResponse> questionResponses = [];

  late Future<LocalResponseList> localResponseListFuture;

  Future<LocalResponseList> initializeLocalResponseList() async {
    final responseList = await _databaseService.getData();
    final LocalResponseList localResponseList = LocalResponseList();
    localResponseList.addResponseListFromMap(responseList);
    return localResponseList;
  }

  @override
  void initState() {
    super.initState();
    localResponseListFuture = initializeLocalResponseList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    appState.historyKey = _key;

    return FutureBuilder<LocalResponseList>(
      future: localResponseListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error has occurred'));
        }

        final localResponseList = snapshot.data!;

        for (int i = 0; i < appState.questionsList.length; i++) {
          if (questionResponses.length <= i) {
            questionResponses.insert(
                0,
                QuestionResponse(
                    question: appState.questionsList[0],
                    response:
                        localResponseList.getRandomResponseWithWeights()));
          }
        }

        return ListView.builder(
          reverse: true,
          itemCount: appState.questionsList.length,
          itemBuilder: (context, index) {
            void likeResponse() {
              setState(() {
                if (!questionResponses[index].response.isLiked) {
                  if (!questionResponses[index].response.isDisliked) {
                    questionResponses[index].response.isLiked = true;
                    _databaseService.vote(questionResponses[index].response.id,
                        "unvoted", "blue");
                  } else {
                    questionResponses[index].response.isLiked = true;
                    questionResponses[index].response.isDisliked = false;
                    _databaseService.vote(
                        questionResponses[index].response.id, "red", "blue");
                  }
                } else {
                  questionResponses[index].response.isLiked = false;
                  _databaseService.vote(
                      questionResponses[index].response.id, "blue", "unvoted");
                }
              });
            }

            void dislikeResponse() {
              setState(() {
                if (!questionResponses[index].response.isDisliked) {
                  if (!questionResponses[index].response.isLiked) {
                    questionResponses[index].response.isDisliked = true;
                    _databaseService.vote(
                        questionResponses[index].response.id, "unvoted", "red");
                  } else {
                    questionResponses[index].response.isDisliked = true;
                    questionResponses[index].response.isLiked = false;
                    _databaseService.vote(
                        questionResponses[index].response.id, "blue", "red");
                  }
                } else {
                  questionResponses[index].response.isDisliked = false;
                  _databaseService.vote(
                      questionResponses[index].response.id, "red", "unvoted");
                }
              });
            }

            // * Thumb icons
            IconData myThumbUp;
            myThumbUp = questionResponses[index].response.isLiked
                ? Icons.thumb_up
                : Icons.thumb_up_outlined;

            IconData myThumbDown;
            myThumbDown = questionResponses[index].response.isDisliked
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
                        questionResponses[index].question,
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
                            questionResponses[index].response.text,
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
