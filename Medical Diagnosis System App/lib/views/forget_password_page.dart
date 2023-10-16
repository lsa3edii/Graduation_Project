import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/helper/helper_functions.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import 'package:medical_diagnosis_system/widgets/custom_button.dart';
import 'package:medical_diagnosis_system/widgets/custom_text_field.dart';
import '../constants.dart';

class ForgetPasswordPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Center(
            child: Text(
          'Medical Diagnosis System',
          style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
        )),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                kDefaultImage,
                height: 200,
                cacheHeight: 200,
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Enter your email address and we will send you an email to reset your password.',
                style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            CustomTextField(
              hintLabel: 'Email',
              icon: Icons.email,
              onChanged: (data) {
                email = data.trim();
              },
            ),
            const SizedBox(height: 25),
            CustomButton2(
              buttonText: 'Reset Password',
              fontFamily: '',
              fontWeight: FontWeight.bold,
              color: Colors.white,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await AuthServices.resetPassword(email: email!);
                    // ignore: use_build_context_synchronously
                    showSnackBar(context,
                        message: 'The password reset email has been sent.',
                        color: Colors.blueGrey[200]);
                  } on FirebaseException {
                    showSnackBar(context,
                        message: 'The email address is badly formatted.',
                        color: Colors.blueGrey[200]);
                  }
                }
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
