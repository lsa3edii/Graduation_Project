import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:medical_diagnosis_system_admin/models/users.dart';
import 'package:medical_diagnosis_system_admin/services/api.dart';
import 'package:http/http.dart' as http;
import '../views/signup_page.dart';
import '../constants.dart';
// import 'package:medical_diagnosis_system/models/users.dart';

class AuthServices {
  // static User? user = FirebaseAuth.instance.currentUser;
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
      await sendVerificationEmail();

      return userCredential;
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-already-in-use') {
        throw Exception('Email already in use !');
      } else if (ex.code == 'weak-password') {
        throw Exception(
            'Weak password, Password must be at least 6 characters !');
      } else {
        throw Exception('An unexpected error occurred.');
      }
    } catch (ex) {
      throw Exception('An unexpected error occurred.');
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
    } on FirebaseAuthException catch (ex) {
      // ex.code dosen't work.
      // if (ex.code == 'user-not-found') {
      //   throw Exception('User not found !');
      // } else if (ex.code == 'wrong-password') {
      //   throw Exception('Wrong password !');
      // }
      if (ex.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw Exception('User not found or Wrong password !');
      } else if (ex.code == 'too-many-requests') {
        throw Exception('You have tried too much, Please try again later !');
      } else {
        throw Exception('An unexpected error occurred.');
      }
    } catch (ex) {
      throw Exception('An unexpected error occurred.');
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
    await FirebaseAuth.instance.signOut();
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

  static Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  static Future<void> resetPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> deleteAccount({int? flag, String? email}) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? userid;
    DocumentReference? firstAdmin = FirebaseFirestore.instance
        .collection('first_registered_admin')
        .doc('first_admin');

    if (user != null) {
      if (flag == 0) {
        userid = await retrieveUserData2(email: email!, field: UserFields.uid);
        await API.deleteUserAuth(uid: userid!);
        await users.doc(userid).delete();
        return;
      }
      await user.delete();
      await users.doc(user.uid).delete();
      if (flag == 1) {
        await firstAdmin.delete();
      }
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

    if (userSnapshot.exists) {
      return userSnapshot[userField];
    }
    return null;
  }

  static Future<String?> retrieveUserData2(
      {required String email, required String field}) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0].get(field);
      }
      return null;
    } on Exception {
      return null;
    }
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

  static Future<bool> isAdminOrDoctorExists(
      {required CollectionReference users, required String userRole}) async {
    try {
      QuerySnapshot querySnapshot =
          await users.where('userRole', isEqualTo: userRole).get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      }
      return false;
    } on Exception {
      return false;
    }
  }

  static Future<bool> checkFirstRegisteredAdmin(
      {required String adminEmail}) async {
    try {
      final CollectionReference firstEmailCollection =
          FirebaseFirestore.instance.collection('first_registered_admin');

      final DocumentSnapshot firstEmailDoc =
          await firstEmailCollection.doc('first_admin').get();

      if (firstEmailDoc.exists) {
        return adminEmail == firstEmailDoc['email'];
      }

      await firstEmailCollection.doc('first_admin').set(
        {
          'email': adminEmail,
        },
      );

      return true;
    } catch (ex) {
      throw Exception(ex);
    }
  }

  // static Future<void> deleteUserAuth({required String uid}) async {
  //   const apiKey = 'AIzaSyBbZY3zVLgBsidvGWMBwYa2olyewwC4nr8';
  //   const url =
  //       'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=$apiKey';

  //   // const userIdToken = '';

  //   http.Response response = await http.post(
  //     Uri.parse(url),
  //     body: '{"localId":"$uid"}',
  //     headers: {
  //       'Content-Type': 'application/json',
  //       // 'Authorization': 'Bearer $userIdToken}',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     // print('Success');
  //   } else {
  //     // print('Failed to delete user: ${response.body}');
  //   }
  // }

  // static Future<bool> checkRegistrationFlag() async {
  //   try {
  //     final CollectionReference flagsCollection =
  //         FirebaseFirestore.instance.collection('registration_flags');

  //     final DocumentSnapshot flagDoc =
  //         await flagsCollection.doc('registration_flag').get();

  //     if (flagDoc.exists) {
  //       return flagDoc['registrationComplete'] == true;
  //     } else {
  //       return false;
  //     }
  //   } catch (ex) {
  //     throw Exception(ex);
  //   }
  // }

  // static Future<void> setRegistrationFlag() async {
  //   try {
  //     final CollectionReference flagsCollection =
  //         FirebaseFirestore.instance.collection('registration_flags');

  //     await flagsCollection.doc('registration_flag').set(
  //       {
  //         'registrationComplete': true,
  //       },
  //     );
  //   } catch (ex) {
  //     throw Exception(ex);
  //   }
  // }

  // static Future<String?> getAdminEmail(
  //     {required CollectionReference users}) async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await users.where('userRole', isEqualTo: 'admin').get();

  //     return querySnapshot.docs[0]['email'];
  //   } on Exception {
  //     return null;
  //   }
  // }

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
