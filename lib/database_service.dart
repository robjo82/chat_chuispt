import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('');

  // get all the texts from the database
  Stream<List<String>> getTexts() {
    return _database.child('questions').onValue.map((event) {
      final texts = <String>[];

      final List<dynamic>? data = event.snapshot.value as List<dynamic>?;
      if (data != null) {
        for (final question in data) {
          final text = question['text'] as String?;
          if (text != null) {
            texts.add(text);
          }
        }
      }

      return texts;
    });
  }

  // data format : {questions: {id: {text: text, blue_thumb: blueThumb, red_thumb: redThumb}}, ...}
  // get all the data from the database
  Stream<List<Map<String, dynamic>>> getData() {
    return _database.child('questions').onValue.map((event) {
      final data = <Map<String, dynamic>>[];

      final Map<dynamic, dynamic>? questions =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (questions != null) {
        questions.forEach((key, value) {
          final Map<dynamic, dynamic>? questionMap =
              value as Map<dynamic, dynamic>?;

          final text = questionMap?['text'] as String?;
          final blueThumb = questionMap?['blue_thumb'] as int?;
          final redThumb = questionMap?['red_thumb'] as int?;

          if (text != null && blueThumb != null && redThumb != null) {
            data.add({
              'id': key,
              'text': text,
              'blue_thumb': blueThumb,
              'red_thumb': redThumb,
            });
          }
        });
      }

      return data;
    });
  }

  // add a new answer to the database, with his id, text, blue thumb and red thumb
  Future<void> addQuestion(String text, int blueThumb, int redThumb) {
    final int questionId = DateTime.now().millisecondsSinceEpoch;
    return _database.child('questions/$questionId').set({
      'text': text,
      'blue_thumb': blueThumb,
      'red_thumb': redThumb,
    });
  }

  // update the blue thumb of a question
  Future<void> updateBlueThumb(String id, int blueThumb) {
    return _database.child('questions').child(id.toString()).update({
      'blue_thumb': blueThumb,
    });
  }

  // update the red thumb of a question
  Future<void> updateRedThumb(String id, int redThumb) {
    return _database.child('questions').child(id.toString()).update({
      'red_thumb': redThumb,
    });
  }

  // delete a question
  Future<void> deleteQuestion(String id) {
    return _database.child('questions').child(id.toString()).remove();
  }
}
