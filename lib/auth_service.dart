import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import '../../models/user.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          '363041976766-tl9dmr417jq5he4trfptd803dqrmrt1n.apps.googleusercontent.com');
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;

  UserRepository() {
    _databaseReference = _firebaseDatabase.ref();
  }

  Future<User?> signInWithGoogle() async {
    if (kDebugMode) {
      print("signInWithGoogle");
    }
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          // Checking if the user is new or already exists
          final isNewUser = userCredential.additionalUserInfo!.isNewUser;
          if (isNewUser) {
            if (kDebugMode) {
              print("New user created");
            }

            // Create a new user instance in the database
            final newUser = {
              "first_connection": DateTime.now().toIso8601String(),
              "first_name": user.displayName?.split(' ')[0],
              "last_connection": DateTime.now().toIso8601String(),
              "email": user.email,
              "last_name": user.displayName!.split(' ').length > 1
                  ? user.displayName?.split(' ')[1]
                  : ''
            };

            await _databaseReference.child('users/${user.uid}').set(newUser);
          } else {
            if (kDebugMode) {
              print("User named ${user.displayName} already exists");
            }
            // Update the last connection time
            await _databaseReference
                .child('users/${user.uid}/last_connection')
                .set(DateTime.now().millisecondsSinceEpoch);
          }
          return user;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }

  User? getCurrentUser() {
    if (kDebugMode) {
      print("getCurrentUser ${_auth.currentUser}");
    }
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      print("signOut");
    }
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<LocalUser?> getUser() async {
    User? currentUser = getCurrentUser();
    if (currentUser != null) {
      String userId = currentUser.uid;
      DatabaseReference userRef = _databaseReference.child('users/$userId');
      DatabaseEvent event = await userRef.once();
      if (kDebugMode) {
        print(event.snapshot.value);
      }
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> userData = event.snapshot.value as Map;
        final Map<String, dynamic> userDataFormatted =
            userData.map<String, dynamic>(
          (key, value) => MapEntry(key.toString(), value),
        );
        return LocalUser.fromMap(userDataFormatted, userId);
      }
    }
    return null;
  }
}
