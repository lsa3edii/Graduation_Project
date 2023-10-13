import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthServices {
  static final GoogleSignIn _gSignIn = GoogleSignIn();

  AuthServices();

  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _gSignIn.signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      return FirebaseAuth.instance.signInWithCredential(credential);
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<void> logout() async {
    try {
      await _gSignIn.disconnect();
    } on Exception {
      //
    }
    FirebaseAuth.instance.signOut();
  }
}
