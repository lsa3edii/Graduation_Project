import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/helper_functions.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Global Varible to fix some problems.
String? username;
String? email;
String? password;
String? messageId;
String? confirmPassword;
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
                child: Image.asset('assets/icons/Medical Diagnosis System.png',
                    height: 200),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text('User Register :',
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
                  icon: Icons.person,
                  onChanged: (data) {
                    username = data;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Email',
                  icon: Icons.email,
                  onChanged: (data) {
                    email = data.trim();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Password',
                  icon: Icons.password,
                  onChanged: (data) {
                    password = data;
                  },
                  obscureText: true,
                ),
              ),
              CustomTextFieldForCheckPassword(
                hintLabel: 'Confirm Password',
                icon: Icons.password,
                onChanged: (data) {
                  confirmPassword = data;
                },
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("already have an account?  "),
                    GestureDetector(
                      onTap: () {
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
                      await registerUser();

                      // ignore: use_build_context_synchronously
                      showSnackBar(context, message: 'Sucsseed.. go to login!');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showSnackBar(context, message: 'Weak password!');
                      } else if (e.code == 'email-already-in-use') {
                        showSnackBar(context,
                            message: 'Email already in use!!');
                      } else {
                        showSnackBar(context, message: e.toString());
                      }
                    } catch (e) {
                      showSnackBar(context, message: e.toString());
                    }
                    setState(() {
                      isLoading = false;
                    });
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

  Future<void> registerUser() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
