import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class LocalQuestion {
  int id = 0;
  String text = "";
  int blueThumb = 0;
  int redThumb = 0;
  int usage = 0;
  double repetitionScore = 1.0;
  double globalScore = 0.0;

  LocalQuestion(
      {required this.id,
      required this.text,
      required this.blueThumb,
      required this.redThumb}) {
    updateGlobalScore();
  }

  String getText() {
    return text;
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

  static LocalQuestion fromJson(Map<String, dynamic>? json) {
    return LocalQuestion(
      id: json?['id'] ?? 0,
      text: json?['text'] ?? "",
      blueThumb: json?['blue_thumb'] ?? 0,
      redThumb: json?['red_thumb'] ?? 0,
    );
  }
}

class QuestionList {
  late List<LocalQuestion> questions;

  QuestionList() {
    questions = [];
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final data = await _getData();

    if (data != null) {
      questions =
          data.map((question) => LocalQuestion.fromJson(question)).toList();
    }
  }

  Future<List<Map<String, dynamic>>?> _getData() async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref("questions");

      final snapshot = await ref.once();
      final value = snapshot.snapshot.value;

      if (value is List) {
        final data = value
            .map((item) => {
                  "id": item["id"],
                  "text": item["text"],
                  "blue_thumb": item["blue_thumb"],
                  "red_thumb": item["red_thumb"],
                })
            .toList();

        return data;
      } else {
        if (kDebugMode) {
          print("Invalid data format");
        }
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error loading questions: $error");
      }
      return null;
    }
  }

  Future<LocalQuestion?> getQuestion() async {
    final choices = <LocalQuestion>[];

    for (final question in questions) {
      final score = question.globalScore * 100;

      for (var i = 0; i < score; i++) {
        choices.add(question);
      }
    }

    return choices.isEmpty ? null : choices[Random().nextInt(choices.length)];
  }

  Future<int?> getBlueThumb(int id) async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref().child("questions/$id/blue_thumb");

      final snapshot = await ref.once();
      final value = snapshot.snapshot.value;

      return value as int?;
    } catch (error) {
      if (kDebugMode) {
        print("Error getting blue thumb count: $error");
      }
      return null;
    }
  }

  Future<void> increaseBlueThumb(int id) async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref().child("questions/$id/blue_thumb");

      final currentCount = await getBlueThumb(id) ?? 0;
      await ref.set(currentCount + 1);
    } catch (error) {
      if (kDebugMode) {
        print("Error increasing blue thumb count: $error");
      }
    }
  }

  Future<int?> getRedThumb(int id) async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref().child("questions/$id/red_thumb");

      final snapshot = await ref.once();
      final value = snapshot.snapshot.value;

      return value as int?;
    } catch (error) {
      if (kDebugMode) {
        print("Error getting red thumb count: $error");
      }
      return null;
    }
  }

  Future<void> increaseRedThumb(int id) async {
    try {
      final database = FirebaseDatabase.instance;
      final ref = database.ref().child("questions/$id/red_thumb");

      final currentCount = await getRedThumb(id) ?? 0;
      await ref.set(currentCount + 1);
    } catch (error) {
      if (kDebugMode) {
        print("Error increasing red thumb count: $error");
      }
    }
  }
}
