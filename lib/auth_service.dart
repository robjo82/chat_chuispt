import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // obtain auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // sign in with Firebase
    final authResult = await _auth.signInWithCredential(credential);

    // check if the user is signed in
    if (authResult != null && authResult.user != null) {
      // User is signed in
      return authResult.user;
    } else {
      // User is not signed in
      return null;
    }
  }

  Future<void> signOut() async {
    // sign out with Firebase and Google
    await _auth.signOut();
    await googleSignIn.signOut();
  }
}
