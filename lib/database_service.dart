import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('');

  // data format : {questions: {id: {text: text, blue_thumb: blueThumb, red_thumb: redThumb}}, ...}
  // get all the data from the database
  Stream<List<Map<String, dynamic>>> getData() {
    return _database.child('responses').onValue.map((event) {
      final data = <Map<String, dynamic>>[];

      final Map<dynamic, dynamic>? responses =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (responses != null) {
        responses.forEach((key, value) {
          final Map<dynamic, dynamic>? responseMap =
              value as Map<dynamic, dynamic>?;

          final text = responseMap?['text'] as String?;
          final blueThumb = responseMap?['blue_thumb'] as int?;
          final redThumb = responseMap?['red_thumb'] as int?;

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
  Future<void> addResponse(String text, int blueThumb, int redThumb) {
    final int responseId = DateTime.now().millisecondsSinceEpoch;
    return _database.child('questions/$responseId').set({
      'text': text,
      'blue_thumb': blueThumb,
      'red_thumb': redThumb,
    });
  }

  // update the blue thumb of a question
  Future<void> updateBlueThumb(String id, int blueThumb) {
    return _database.child('responses').child(id.toString()).update({
      'blue_thumb': blueThumb,
    });
  }

  // update the red thumb of a question
  Future<void> updateRedThumb(String id, int redThumb) {
    return _database.child('responses').child(id.toString()).update({
      'red_thumb': redThumb,
    });
  }

  // delete a question
  Future<void> deleteQuestion(String id) {
    return _database.child('responses').child(id.toString()).remove();
  }
}
