import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import '../widgets/custom_text_field.dart';

void showSnackBar(BuildContext context,
    {required String message, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(
              fontSize: 17, fontFamily: 'Pacifico', color: kPrimaryColor)),
      backgroundColor: color ?? Colors.grey[200],
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
