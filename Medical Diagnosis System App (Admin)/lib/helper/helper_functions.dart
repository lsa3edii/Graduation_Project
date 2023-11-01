import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../widgets/custom_text_field.dart';

void showSnackBar(BuildContext context,
    {required String message, Color? color}) {
  final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
  if (scaffoldMessenger != null) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
        backgroundColor: color ?? Colors.white,
      ),
    );
  }
}

void clearAdminData() {
  controllerAdminEmail.clear();
  controllerAdminPassowrd.clear();
  controllerUsernameAdminHome.clear();
  controllerPasswordAdminHome.clear();
}

void clearSignUpDataAdmin() {
  controllerEmailAdminSignUP.clear();
  controllerPasswordAdminSignUP.clear();
  controllerConfirmPasswordAdminSignUP.clear();
  controllerUsernameAdminSignUP.clear();
}

void clearSignUpDataUser() {
  controllerEmailUserSignUP.clear();
  controllerPasswordUserSignUP.clear();
  controllerConfirmPasswordUserSignUP.clear();
  controllerUsernameUserSignUP.clear();
}

void clearSignUpDataDoctor() {
  controllerEmailDoctorSignUP.clear();
  controllerPasswordDoctorSignUP.clear();
  controllerConfirmPasswordDoctorSignUP.clear();
  controllerUsernameDoctorSignUP.clear();
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

dynamic showDeletionDialog({
  required BuildContext context,
  required VoidCallback onPressed,
  int flag = 0,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            Text(
              ' Confirm Deletion !',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.red),
            ),
          ],
        ),
        content: Text(
          flag == 0
              ? 'Are you sure you want to delete your account?'
              : 'Are you sure you want to delete this account',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.red[700])),
            child: const Text(
              'OK',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unFocus(context);
            },
            style: ButtonStyle(
                overlayColor: MaterialStatePropertyAll(Colors.grey[300])),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

int _backButtonPressCount = 0;
Future<bool> handleOnWillPop({required BuildContext context}) async {
  if (_backButtonPressCount == 1) {
    _backButtonPressCount = 0;
    SystemNavigator.pop();
  } else {
    showSnackBar(context, message: 'Press back again to exit.');
    _backButtonPressCount++;

    Timer(const Duration(seconds: 2), () {
      _backButtonPressCount = 0;
    });
  }
  return false;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
