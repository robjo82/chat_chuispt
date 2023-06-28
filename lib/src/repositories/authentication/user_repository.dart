import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

import 'package:chat_chuispt/src/models/user.dart';

// Classe pour gérer les interactions avec les utilisateurs
class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;

  UserRepository() {
    _databaseReference = _firebaseDatabase.ref();
  }

  // Méthode pour se connecter avec Google
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
          // Vérifier si l'utilisateur est nouveau ou existe déjà
          final isNewUser = userCredential.additionalUserInfo!.isNewUser;
          if (isNewUser) {
            if (kDebugMode) {
              print("New user created");
            }

            // Créer une nouvelle instance d'utilisateur dans la base de données
            final newUser = {
              "first_connection": DateTime.now().toIso8601String(),
              "first_name": user.displayName?.split(' ')[0],
              "last_connection": DateTime.now().toIso8601String(),
              "last_name": user.displayName!.split(' ').length > 1
                  ? user.displayName?.split(' ')[1]
                  : '',
              "blue_thummbs": null,
              "red_thummbs": null
            };

            await _databaseReference.child('users/${user.uid}').set(newUser);
          } else {
            if (kDebugMode) {
              print("User named ${user.displayName} already exists");
            }
            // Mettre à jour la dernière connexion
            await _databaseReference
                .child('users/${user.uid}/last_connection')
                .set(DateTime.now().toIso8601String());
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

  // Méthode pour obtenir l'utilisateur actuel
  User? getCurrentUser() {
    if (kDebugMode) {
      print("getCurrentUser ${_auth.currentUser}");
    }
    return _auth.currentUser;
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    if (kDebugMode) {
      print("signOut");
    }
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Méthode pour obtenir les informations de l'utilisateur
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
        // Convertir les données de l'utilisateur en une instance de LocalUser
        return LocalUser.fromMap(userDataFormatted, userId);
      }
    }
    // Retourne null si aucune donnée utilisateur n'est trouvée
    return null;
  }
}
