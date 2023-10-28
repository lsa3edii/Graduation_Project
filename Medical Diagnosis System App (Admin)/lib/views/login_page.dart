import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system_admin/views/signup_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/helper_functions.dart';
import '../models/users.dart';
import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';
import '../constants.dart';
import 'forget_password_page.dart';
import 'home_admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text('Admin Login :',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Pacifico',
                      color: kPrimaryColor,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7, bottom: 12),
                child: CustomTextField(
                  hintLabel: 'Email',
                  icon: Icons.email,
                  controller: controllerAdminEmail,
                  onChanged: (data) {
                    mainEmail = data.trim();
                  },
                ),
              ),
              CustomTextField(
                icon: Icons.password,
                hintLabel: 'Password',
                controller: controllerAdminPassowrd,
                showVisibilityToggle: true,
                obscureText: true,
                onChanged: (data) {
                  mainPassword = data;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("don't have an account?  "),
                    GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignupPage();
                        }));
                        unFocus(context);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                buttonText: 'Login',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        isLoading = true;
                      });

                      userCredential =
                          await AuthServices.signInWithEmailAndPassword(
                              email: mainEmail!, password: mainPassword!);

                      userRole = await AuthServices.retrieveUserData(
                          userCredential: userCredential!,
                          userField: UserFields.userRole);

                      user = FirebaseAuth.instance.currentUser;
                      if (user!.emailVerified) {
                        if (userRole == userRole3) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const AdminHomePage();
                            }),
                          );
                          // ignore: use_build_context_synchronously
                          showSnackBar(context, message: 'Login Succeeded!');
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar(context,
                              message: 'Something went wrong! Try again.');
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        showSnackBar(context,
                            message: "your account hasn't been activated yet!");
                      }
                    } on FirebaseAuthException catch (e) {
                      showSnackBar(context,
                          message: e.toString().replaceAll('Exception: ', ''));
                    } catch (e) {
                      showSnackBar(context,
                          message: e.toString().replaceAll('Exception: ', ''));
                    } finally {
                      unFocus(context);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    showSnackBar(context, message: 'Login Failed!');
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgetPasswordPage(),
                        ));
                    unFocus(context);
                  },
                  child: const Text(
                    'Forget Password ?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Divider(
                indent: 25,
                endIndent: 25,
                thickness: 1,
                color: Colors.grey,
              ),
              const Center(
                child: Text(
                  'Or Register and Login with',
                  style: TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconAuth(
                    image: 'assets/icons/google.png',
                    onPressed: () async {
                      try {
                        await AuthServices.logout();

                        userCredential = await AuthServices.signInWithGoogle(
                            userRole: userRole3);

                        bool isEmailMatched =
                            await AuthServices.checkFirstRegisteredAdmin(
                                adminEmail: userCredential!.user!.email!);

                        if (isEmailMatched) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminHomePage(),
                              ));
                          // ignore: use_build_context_synchronously
                          showSnackBar(
                            context,
                            message: 'Google Login Succeeded!',
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          showSnackBar(
                            context,
                            message:
                                'Google login is not available for this account.',
                          );
                          // await AuthServices.deleteAccount();
                          await AuthServices.signInWithGoogle(
                              userRole: userRole1);
                          await AuthServices.logout();
                        }
                      } on Exception {
                        // ignore: use_build_context_synchronously
                        showSnackBar(
                          context,
                          message: 'Google Login Failed!',
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 15),
                  IconAuth(
                    image: 'assets/icons/facebook.png',
                    onPressed: () async {
                      try {
                        userCredential = await AuthServices.signInWithFacebook(
                            userRole: userRole3);
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AdminHomePage(),
                            ));
                        // ignore: use_build_context_synchronously
                        showSnackBar(
                          context,
                          message: 'Facebook Login Succeeded!',
                        );
                      } on Exception {
                        showSnackBar(
                          context,
                          message: 'Facebook Login Failed!',
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
