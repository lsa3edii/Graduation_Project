import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/helper_functions.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Global Varible to fix some problems.
String? username;
String? email;
String? password;
String? chatId;
String? confirmPassword;

User? user = FirebaseAuth.instance.currentUser;

UserCredential? userCredential;
CollectionReference users = FirebaseFirestore.instance.collection(kUsers);
CollectionReference chats =
    FirebaseFirestore.instance.collection(kChatCollection);

String? userRole;

bool isDarkMode = false;
// int? page;

class SignupUserPage extends StatefulWidget {
  const SignupUserPage({super.key});

  @override
  State<SignupUserPage> createState() => _SignupUserPageState();
}

class _SignupUserPageState extends State<SignupUserPage> {
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            'Medical Diagnosis System',
            style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
          ),
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
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text('User Registration :',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Pacifico',
                      color: kPrimaryColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Username',
                  controller: controllerUsernameSignUP,
                  maxLength: 12,
                  icon: Icons.person,
                  onChanged: (data) {
                    username = data.trim();
                    if (username!.isEmpty) {
                      username = null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Email',
                  controller: controllerEmailSignUP,
                  icon: Icons.email,
                  onChanged: (data) {
                    email = data.trim();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomTextField(
                  icon: Icons.password,
                  hintLabel: 'Password',
                  controller: controllerPasswordSignUP,
                  obscureText: true,
                  showVisibilityToggle: true,
                  onChanged: (data) {
                    password = data;
                  },
                ),
              ),
              CustomTextFieldForCheckPassword(
                icon: Icons.password,
                hintLabel: 'Confirm Password',
                controller: controllerConfirmPasswordSignUP,
                obscureText: true,
                onChanged: (data) {
                  confirmPassword = data;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account?  "),
                    GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                buttonText: 'Sign Up',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      await AuthServices.registerWithEmailAndPassword(
                        email: email!,
                        password: password!,
                        username: username!,
                        userRole: userRole1,
                      );
                      // AuthServices.logout(); // to solve a problem
                      clearUserSignUpData();

                      // ignore: use_build_context_synchronously
                      unFocus(context);

                      // ignore: use_build_context_synchronously
                      showSnackBar(context,
                          message:
                              'Success.. We will send you an email to verify your account.');

                      await Future.delayed(const Duration(seconds: 2));

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      showSnackBar(context,
                          message: e.toString().replaceAll('Exception: ', ''));
                    } catch (e) {
                      showSnackBar(context,
                          message: e.toString().replaceAll('Exception: ', ''));
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    showSnackBar(context, message: 'Error!');
                  }
                },
              ),
              const SizedBox(height: 75)
            ],
          ),
        ),
      ),
    );
  }
}
