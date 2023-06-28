import 'package:chat_chuispt/src/models/user.dart';
import 'package:firebase_database/firebase_database.dart';

import '../authentication/user_repository.dart';

class DatabaseService {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref('');

  final UserRepository _userRepository = UserRepository();

  // data format : {responses: {id: {text: text, blue_thumb: blueThumb, red_thumb: redThumb}}, ...}
  // Fetches all the data from the database
  Future<List<Map<String, dynamic>>> getData() async {
    final List<Map<String, dynamic>> data = [];

    final DatabaseEvent databaseEvent =
        await _databaseReference.child('responses').once();
    final Map<dynamic, dynamic>? responses =
        databaseEvent.snapshot.value as Map<dynamic, dynamic>?;
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

  // vote for a response
  Future<void> vote(String resopnseId, String lastVote, String newVote) async {
    /**
     * votes could be blue, red or unvoted
     * 
     * there is 9 possible cases :
     * - null -> null, blue -> blue, red -> red => do nothing
     * - null -> blue => add blue to "vote" on the response on the user, add responseId to "favorites" on the user, add 1 to blue_thumb on the response
     * - null -> red => add red to "vote" on the response on the user, add 1 to red_thumb on the response
     * - blue -> null => remove blue from "vote" on the response on the user, remove responseId from "favorites" on the user, remove 1 to blue_thumb on the response
     * - red -> null => remove red from "vote" on the response on the user, remove 1 to red_thumb on the response
     * - blue -> red => set red to "vote" on the response on the user, remove responseId from "favorites" on the user, remove 1 to blue_thumb on the response, add 1 to red_thumb on the response
     * - red -> blue => set blue to "vote" on the response on the user, add responseId to "favorites" on the user, add 1 to blue_thumb on the response, remove 1 to red_thumb on the response
    */

    LocalUser? user = await _userRepository.getUser();
    String userId;
    if (user != null) {
      userId = user.id;
    } else {
      throw Exception("User not found");
    }

    if (lastVote == newVote) {
      return Future.value();
    } else if (lastVote == "unvoted" && newVote == "blue") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .set("blue");
      _databaseReference
          .child('users')
          .child("$userId/favorites")
          .child(resopnseId)
          .set(true);
      return _databaseReference.child('responses').child(resopnseId).update({
        'blue_thumb': ServerValue.increment(1),
      });
    } else if (lastVote == "unvoted" && newVote == "red") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .set("red");
      return _databaseReference.child('responses').child(resopnseId).update({
        'red_thumb': ServerValue.increment(1),
      });
    } else if (lastVote == "blue" && newVote == "unvoted") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .remove();
      _databaseReference
          .child('users')
          .child("$userId/favorites")
          .child(resopnseId)
          .remove();
      return _databaseReference.child('responses').child(resopnseId).update({
        'blue_thumb': ServerValue.increment(-1),
      });
    } else if (lastVote == "red" && newVote == "unvoted") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .remove();
      return _databaseReference.child('responses').child(resopnseId).update({
        'red_thumb': ServerValue.increment(-1),
      });
    } else if (lastVote == "blue" && newVote == "red") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .set("red");
      _databaseReference
          .child('users')
          .child("$userId/favorites")
          .child(resopnseId)
          .remove();
      return _databaseReference.child('responses').child(resopnseId).update({
        'blue_thumb': ServerValue.increment(-1),
        'red_thumb': ServerValue.increment(1),
      });
    } else if (lastVote == "red" && newVote == "blue") {
      _databaseReference
          .child('users')
          .child("$userId/vote")
          .child(resopnseId)
          .set("blue");
      _databaseReference
          .child('users')
          .child("$userId/favorites")
          .child(resopnseId)
          .set(true);
      return _databaseReference.child('responses').child(resopnseId).update({
        'blue_thumb': ServerValue.increment(1),
        'red_thumb': ServerValue.increment(-1),
      });
    } else {
      return Future.value();
    }
  }
}
