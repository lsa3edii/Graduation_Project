import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:http/http.dart' as http;
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

      dynamic username = userCredential.user!.displayName;
      if (username != null) {
        if (username.length > 12) {
          username = username.split(' ')[0];
        }
      }

      createUserCollection(
        userCredential: userCredential,
        email: userCredential.user!.email!,
        userRole: userRole,
        username: username,
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

  static void deleteAccount() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.delete();
      users.doc(user.uid).delete();
    }
  }

  static Future<String?> retrieveUserData({
    required UserCredential? userCredential,
    required String userField,
    String? uid,
  }) async {
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection(kUsers)
        .doc(uid ?? userCredential!.user!.uid)
        .get();

    return userSnapshot[userField];
  }

  static bool isUserAuthenticatedWithGoogle() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      for (var info in user.providerData) {
        if (info.providerId == 'google.com') {
          return true;
        }
      }
    }
    return false;
  }

  static void uploadImage({required String email, File? img}) {
    final path = '${email.split('@')[0]}.jpg';
    final ref = FirebaseStorage.instance.ref().child(path);

    if (img != null) {
      ref.putFile(img);
    }
  }

  static Future<String?> retrieveImage({String? email}) async {
    if (email != null) {
      final path = '${email.split('@')[0]}.jpg';
      final ref = FirebaseStorage.instance.ref().child(path);

      try {
        final url = await ref.getDownloadURL();
        return url;
      } on Exception {
        return null;
      }
    }
    return null;
  }

  static void uploadImage2(
      {required String email, required String photoURL}) async {
    final path = '${email.split('@')[0]}.jpg';
    final Reference storageRef = FirebaseStorage.instance.ref().child(path);

    try {
      final http.Response response = await http.get(Uri.parse(photoURL));
      final Uint8List imageData = response.bodyBytes;
      storageRef.putData(
          imageData, SettableMetadata(contentType: 'image/jpeg'));
    } on Exception {
      //
    }
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
