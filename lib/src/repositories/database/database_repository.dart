import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('');

  // data format : {responses: {id: {text: text, blue_thumb: blueThumb, red_thumb: redThumb}}, ...}
  // Fetches all the data from the database
  Stream<List<Map<String, dynamic>>> getData() {
    return _databaseReference.child('responses').onValue.map((event) {
      final List<Map<String, dynamic>> data = [];

      final Map<dynamic, dynamic>? responses =
          event.snapshot.value as Map<dynamic, dynamic>?;
      if (responses != null) {
        responses.forEach((key, value) {
          final Map<dynamic, dynamic>? responseMap =
              value as Map<dynamic, dynamic>?;

          final String? text = responseMap?['text'] as String?;
          final int? blueThumb = responseMap?['blue_thumb'] as int?;
          final int? redThumb = responseMap?['red_thumb'] as int?;

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

  // add a new answer to the database, with its id, text, blue thumb and red thumb
  Future<void> addResponse(String text, int blueThumb, int redThumb) {
    final int responseId = DateTime.now().millisecondsSinceEpoch;
    return _databaseReference.child('responses/$responseId').set({
      'text': text,
      'blue_thumb': blueThumb,
      'red_thumb': redThumb,
    });
  }

  // Updates the blue thumb of a question
  Future<void> updateBlueThumb(String id, int blueThumb) {
    return _databaseReference.child('responses').child(id.toString()).update({
      'blue_thumb': blueThumb,
    });
  }

  // Updates the red thumb of a question
  Future<void> updateRedThumb(String id, int redThumb) {
    return _databaseReference.child('responses').child(id.toString()).update({
      'red_thumb': redThumb,
    });
  }

  // delete a question
  Future<void> deleteResponse(String id) {
    return _databaseReference.child('responses').child(id.toString()).remove();
  }
}
