import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:medical_diagnosis_system/constants.dart';
// import 'package:medical_diagnosis_system/models/users.dart';

class AuthServices {
  static final GoogleSignIn _gSignIn = GoogleSignIn();

  AuthServices();

  static Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String userRole,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      createUserCollection(
        userCredential: userCredential,
        email: email,
        password: password,
        username: username,
        userRole: userRole,
      );

      return userCredential;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
    // required String userRole,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // _createUserCollection(
      //   userCredential: userCredential,
      //   email: email,
      //   password: password,
      //   userRole: userRole,
      // );

      return userCredential;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithGoogle(
      {required String userRole}) async {
    try {
      final GoogleSignInAccount? gUser = await _gSignIn.signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      createUserCollection(
        userCredential: userCredential,
        email: userCredential.user!.email!,
        userRole: userRole,
        // username: await retriveUserData(
        //     userCredential: userCredential, userField: UserFields.username),
        // password: await retriveUserData(
        //     userCredential: userCredential, userField: UserFields.password),
      );

      return userCredential;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  static Future<UserCredential> signInWithFacebook(
      {required String userRole}) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      createUserCollection(
        userCredential: userCredential,
        email: userCredential.user!.email!,
        userRole: userRole,
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

  static void createUserCollection({
    required UserCredential userCredential,
    required String email,
    required String userRole,
    String? password,
    String? username,
  }) {
    CollectionReference users = FirebaseFirestore.instance.collection(kUsers);
    users.doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
      'password': password,
      'username': username,
      'userRole': userRole,
    }, SetOptions(merge: true));
  }

  static Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<String?> retriveUserData(
      {required UserCredential userCredential,
      required String userField}) async {
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(kUsers)
        .doc(userCredential.user!.uid)
        .get();
    return userSnapshot[userField];
  }

  // static Future<void> updatePassword({
  //   required UserCredential userCredential,
  //   required String email,
  //   required String oldPassword,
  //   required String newPassword,
  // }) async {
  //   var credential =
  //       EmailAuthProvider.credential(email: email, password: oldPassword);

  //   await userCredential.user!
  //       .reauthenticateWithCredential(credential)
  //       .then((value) => userCredential.user!.updatePassword(newPassword));
  // }
}
