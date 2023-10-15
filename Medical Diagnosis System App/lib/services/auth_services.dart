import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:medical_diagnosis_system/constants.dart';

class AuthServices {
  static final GoogleSignIn _gSignIn = GoogleSignIn();

  AuthServices();

  static Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _createUserCollection(
        userCredential: userCredential,
        email: email,
        password: password,
        username: username,
      );

      return userCredential;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _createUserCollection(
        userCredential: userCredential,
        email: email,
        password: password,
      );

      return userCredential;
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

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _createUserCollection(
        userCredential: userCredential,
        email: userCredential.user!.email!,
      );

      return userCredential;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      _createUserCollection(
        userCredential: userCredential,
        email: userCredential.user!.email!,
      );

      return userCredential;
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

  static void _createUserCollection({
    required UserCredential userCredential,
    required String email,
    String? password,
    String? username,
  }) {
    CollectionReference users = FirebaseFirestore.instance.collection(kUsers);
    users.doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'password': password,
      'username': username,
    }, SetOptions(merge: true));
  }
}
