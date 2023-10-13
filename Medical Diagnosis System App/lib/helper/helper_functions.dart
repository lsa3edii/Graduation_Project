import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import '../widgets/custom_text_field.dart';

void showSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: kPrimaryColor)),
      backgroundColor: Colors.white,
    ),
  );
}

void clearUserData() {
  controllerUserEmail.clear();
  controllerUserPassowrd.clear();
}

void clearDoctorData() {
  controllerDoctorEmail.clear();
  controllerDoctorPassowrd.clear();
}

void unFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}