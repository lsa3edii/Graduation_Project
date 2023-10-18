import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import 'package:medical_diagnosis_system/views/forget_password_page.dart';
import 'package:medical_diagnosis_system/views/home_doctor.dart';
import 'package:medical_diagnosis_system/views/home_user.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../helper/helper_functions.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _page = 0;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   page = 0;
  // }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 0;
              unFocus(context);
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
              unFocus(context);
            });
          }
        },
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
          bottomNavigationBar: CurvedNavigationBar(
            index: _page,
            height: 55,
            letIndexChange: (index) => true,
            animationDuration: const Duration(milliseconds: 300),
            color: kPrimaryColor,
            backgroundColor: Colors.white,
            items: const <Widget>[
              Icon(Icons.person, color: Colors.white),
              Icon(Icons.medical_information, color: Colors.white),
              // Image.asset('assets/icons/doctor.png')
            ],
            onTap: (value) {
              Feedback.forTap(context);
              setState(() {
                _page = value;
                unFocus(context);
              });
            },
          ),
          body: Form(
              key: formKey,
              child: _page == 0
                  ? ListView(
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
                          child: Text('User Login :',
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
                            controller: controllerUserEmail,
                            onChanged: (data) {
                              chatId = email = data.trim();
                            },
                          ),
                        ),
                        CustomTextField(
                          // icon: Icons.password,
                          hintLabel: 'Password',
                          controller: controllerUserPassowrd,
                          showVisibilityToggle: true,
                          obscureText: true,
                          onChanged: (data) {
                            password = data;
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
                                    return const SignupUserPage();
                                  }));
                                  unFocus(context);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor),
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
                                usercredential = await AuthServices
                                    .signInWithEmailAndPassword(
                                  email: email!,
                                  password: password!,
                                );
                                // ignore: use_build_context_synchronously
                                showSnackBar(context,
                                    message: 'Login Succeeded!');

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const UserHomePage();
                                  }),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showSnackBar(context,
                                      message: 'User not found!');
                                } else if (e.code == 'wrong-password') {
                                  showSnackBar(context,
                                      message: 'Wrong password!');
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
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
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
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'Pacifico'),
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
                                  usercredential =
                                      await AuthServices.signInWithGoogle();
                                  chatId = usercredential!.user!.email;
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserHomePage(),
                                      ));
                                  // ignore: use_build_context_synchronously
                                  showSnackBar(
                                    context,
                                    message: 'Google Login Succeeded!',
                                  );
                                } on Exception {
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
                                  usercredential =
                                      await AuthServices.signInWithFacebook();
                                  chatId = usercredential!.user!.email;
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserHomePage(),
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
                    )
                  : ListView(
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
                          child: Text('Doctor Login :',
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'Pacifico',
                                color: kPrimaryColor,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7, bottom: 12),
                          child: CustomTextField2(
                            hintLabel: 'Email',
                            icon: Icons.email,
                            controller: controllerDoctorEmail,
                            onChanged: (data) {
                              chatId = email = data.trim();
                            },
                          ),
                        ),
                        CustomTextField2(
                          hintLabel: 'Password',
                          obscureText: true,
                          showVisibilityToggle: true,
                          controller: controllerDoctorPassowrd,
                          onChanged: (data) {
                            password = data;
                          },
                        ),
                        const SizedBox(height: 51),
                        CustomButton(
                          buttonText: 'Login',
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const DoctorHomePage();
                              }),
                            );
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                // await AuthServices.signInWithEmailAndPassword(
                                //   email!,
                                //   password!,
                                // );

                                // // ignore: use_build_context_synchronously
                                // showSnackBar(context,
                                //     message: 'Login succeeded!',
                                //     color: Colors.white);

                                // // ignore: use_build_context_synchronously
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return const DoctorHomePage();
                                //   }),
                                // );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showSnackBar(context,
                                      message: 'User not found!');
                                } else if (e.code == 'wrong-password') {
                                  showSnackBar(context,
                                      message: 'Wrong password!');
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
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50)
                      ],
                    )),
        ),
      ),
    );
  }
}
