import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_diagnosis_system/constants.dart';
import '../widgets/custom_text_field.dart';

void showSnackBar(BuildContext context,
    {required String message, Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: kPrimaryColor)),
      backgroundColor: color ?? Colors.white,
    ),
  );
}

void clearUserData() {
  controllerUserEmail.clear();
  controllerUserPassowrd.clear();
  controllerUsernameUserHome.clear();
  controllerPasswordUserHome.clear();
}

void clearUserSignUpData() {
  controllerEmailSignUP.clear();
  controllerPasswordSignUP.clear();
  controllerConfirmPasswordSignUP.clear();
  controllerUsernameSignUP.clear();
}

void clearDoctorData() {
  controllerDoctorEmail.clear();
  controllerDoctorPassowrd.clear();
  controllerUsernameDoctorHome.clear();
  controllerPasswordDoctorHome.clear();
}

void unFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

Future<File?> pickImage(
    {required var imageSource, required dynamic pickedFile}) async {
  final picker = ImagePicker();
  pickedFile = await picker.pickImage(source: imageSource);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

dynamic showSheet({
  required BuildContext context,
  required List choices,
  required Function(int) onChoiceSelected,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 112,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: choices.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                choices[i],
                style: const TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                onChoiceSelected(i);
              },
            );
          },
        ),
      );
    },
  );
}

dynamic showMyDialog(
    {required BuildContext context, required VoidCallback onPressed}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Confirm Deletion !',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text('Are you sure you want to delete your account?'),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
