import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/helper_functions.dart';
import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../constants.dart';

// Global Varible to fix some problems.
String? mainEmail;
String? mainPassword;

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

class SignupPage extends StatefulWidget {
  final String? operationType;

  final TextEditingController? controllerUsernameSignUP;
  final TextEditingController? controllerEmailSignUP;
  final TextEditingController? controllerPasswordSignUP;
  final TextEditingController? controllerConfirmPasswordSignUP;

  const SignupPage({
    super.key,
    this.operationType,
    this.controllerUsernameSignUP,
    this.controllerEmailSignUP,
    this.controllerPasswordSignUP,
    this.controllerConfirmPasswordSignUP,
  });

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
              widget.operationType != null
                  ? const Padding(padding: EdgeInsets.only(top: 75))
                  : Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Image.asset(
                        kDefaultImage,
                        height: 200,
                        cacheHeight: 200,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                    widget.operationType?.replaceAll(widget.operationType ?? '',
                            '${widget.operationType} :') ??
                        'Admin Registration :',
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Pacifico',
                      color: kPrimaryColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Username',
                  controller: widget.controllerUsernameSignUP ??
                      controllerUsernameAdminSignUP,
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
                  controller: widget.controllerEmailSignUP ??
                      controllerEmailAdminSignUP,
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
                  controller: widget.controllerPasswordSignUP ??
                      controllerPasswordAdminSignUP,
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
                controller: widget.controllerConfirmPasswordSignUP ??
                    controllerConfirmPasswordAdminSignUP,
                obscureText: true,
                onChanged: (data) {
                  confirmPassword = data;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: widget.operationType != null
                    ? null
                    : Row(
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
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
              ),
              CustomButton(
                buttonText: widget.operationType ?? 'Sign Up',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      if (widget.operationType == null) {
                        if (!await AuthServices.isAdminOrDoctorExists(
                            users: users, userRole: userRole3)) {
                          await AuthServices.registerWithEmailAndPassword(
                            email: email!,
                            password: password!,
                            username: username!,
                            userRole: userRole3,
                          );
                          await AuthServices.checkFirstRegisteredAdmin(
                            adminEmail: email!,
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context,
                              message:
                                  'There is already an admin in the system, and only one admin is allowed.');
                          return;
                        }
                      } else if (widget.operationType == 'Add User') {
                        if (AuthServices.isUserAuthenticatedWithGoogle()) {
                          await AuthServices.registerWithEmailAndPassword(
                            email: email!,
                            password: password!,
                            username: username!,
                            userRole: userRole1,
                          );
                          await AuthServices.signInWithGoogle(
                              userRole: userRole3);
                        } else {
                          await AuthServices.registerWithEmailAndPassword(
                            email: email!,
                            password: password!,
                            username: username!,
                            userRole: userRole1,
                          );
                          await AuthServices.signInWithEmailAndPassword(
                              email: mainEmail!, password: mainPassword!);
                        }
                      } else if (widget.operationType == 'Add Doctor') {
                        if (!await AuthServices.isAdminOrDoctorExists(
                            users: users, userRole: userRole2)) {
                          if (AuthServices.isUserAuthenticatedWithGoogle()) {
                            await AuthServices.registerWithEmailAndPassword(
                              email: email!,
                              password: password!,
                              username: username!,
                              userRole: userRole2,
                            );
                            await AuthServices.signInWithGoogle(
                                userRole: userRole3);
                          } else {
                            await AuthServices.registerWithEmailAndPassword(
                              email: email!,
                              password: password!,
                              username: username!,
                              userRole: userRole2,
                            );
                            await AuthServices.signInWithEmailAndPassword(
                                email: mainEmail!, password: mainPassword!);
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context,
                              message:
                                  'There is already an doctor in the system, and only one doctor is allowed.');
                          return;
                        }
                      }
                      // AuthServices.logout(); // to solve a problem

                      clearSignUpDataAdmin();
                      clearSignUpDataUser();
                      clearSignUpDataDoctor();

                      // ignore: use_build_context_synchronously
                      unFocus(context);

                      if (widget.operationType == null) {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context,
                            message:
                                'Success.. We will send you an email to verify your account.');
                      } else {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context,
                            message:
                                'Success.. We will send an email to this account to verify it.');
                      }

                      if (widget.operationType == null) {
                        await Future.delayed(const Duration(seconds: 2));
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
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
