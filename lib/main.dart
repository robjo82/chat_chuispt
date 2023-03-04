import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  Future<Object?> getBlueThumb(id) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("questions/$id/blue_thumb");

    return ref.once().then((event) {
      return event.snapshot.value;
    });
  }

  void increaseBlueThumb(id) async {
    int blueThumb = await getBlueThumb(id) as int;
    blueThumb++;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("questions/$id/blue_thumb");

    await ref.set(blueThumb);
  }

  Future<Object?> getRedThumb(id) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("questions/$id/red_thumb");

    return ref.once().then((event) {
      return event.snapshot.value;
    });
  }

  void increaseRedThumb(id) async {
    int blueThumb = await getBlueThumb(id) as int;
    blueThumb++;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("questions/$id/red_thumb");

    await ref.set(blueThumb);
  }

  /// Get data from Firebase at questions/$id/text
  /// Return a Future<String>
  Future<Object?> getData(id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("questions/$id/text");

    DatabaseEvent event = await ref.once();
    return event.snapshot.value;
  }

  QuestionList questionList = QuestionList();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(children: [
          ElevatedButton(
            onPressed: () {
              increaseBlueThumb(Random().nextInt(3));
            },
            child: const Text("Increase blue thumb"),
          ),
          ElevatedButton(
              onPressed: () {
                increaseRedThumb(Random().nextInt(3));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text("Increase red thumb")),
          FutureBuilder(
              future: questionList.getQuestion(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                } else {
                  return const CircularProgressIndicator();
                }
              }),
        ])),
      ),
    );
  }
}

class LocalQuestion {
  int id = 0;
  String text = "";
  int blueThumb = 0;
  int redThumb = 0;
  int usage = 0;
  double repetitionScore = 0.0;
  double globalScore = 0.0;

  LocalQuestion(this.id, this.text, this.blueThumb, this.redThumb) {
    usage = 0;
    repetitionScore = 1.0;
    updateGlobalScore();
  }

  void increaseBlueThumb() {
    blueThumb++;
  }

  void increaseRedThumb() {
    redThumb++;
  }

  void increaseUsage() {
    usage++;
  }

  void addUsage(int elementNumber) {
    usage++;
    repetitionScore /= elementNumber;
    updateGlobalScore();
  }

  void addNonUsage(int elementNumber) {
    repetitionScore *= (1 + 1 / elementNumber);
    updateGlobalScore();
  }

  void updateGlobalScore() {
    globalScore = blueThumb / redThumb * repetitionScore;
  }
}

class QuestionList {
  List<LocalQuestion> questions = [];

  QuestionList() {
    questions = [];

    Future<List<Map<String, Object>>?> data = getData();

    data.then((value) {
      if (value != null) {
        for (int i = 0; i < value.length; i++) {
          int? id = value[i]["id"] as int?;
          String? text = value[i]["text"] as String?;
          int? blueThumb = value[i]["blue_thumb"] as int?;
          int? redThumb = value[i]["red_thumb"] as int?;

          questions.add(LocalQuestion(id!, text!, blueThumb!, redThumb!));
        }
      }
    });
  }

  // Get data from Firebase at questions/
  // ignore: slash_for_doc_comments
  /** Data format:
   * [
    {
      "blue_thumb": 89,
      "id": 0,
      "red_thumb": 90,
      "text": "J'ai croisé un gars son front c'est un scenic"
    },
    {
      "blue_thumb": 48,
      "id": 1,
      "red_thumb": 49,
      "text": "Pour ouvrir une porte, il ne faut pas mettre son ventre dans le pédiluve"
    },
    {
      "blue_thumb": 7,
      "id": 2,
      "red_thumb": 8,
      "text": "Mon comptable rêve de bible et de gros chiffres."
    }
  ]
   */
  Future<List<Map<String, Object>>?> getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("questions");

    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      parseData(data) {
        List<Map<String, Object>>? list = data as List<Map<String, Object>>?;
        return list;
      }

      Future<List<Map<String, Object>>?> data =
          compute(parseData, event.snapshot.value);
      return data;
    } else {
      return null;
    }
  }

  Future<LocalQuestion?> getQuestion() async {
    List<LocalQuestion> choices = [];
    for (int i = 0; i < questions.length; i++) {
      for (int j = 0; j < questions[i].globalScore * 100; j++) {
        choices.add(questions[i]);
      }
    }

    return choices[Random().nextInt(choices.length)];
  }
}
