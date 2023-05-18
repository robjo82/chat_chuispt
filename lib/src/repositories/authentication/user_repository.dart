import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

// Classe pour gérer les interactions avec les utilisateurs
class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
            return user;
          }
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
}
