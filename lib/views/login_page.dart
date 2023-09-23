import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/views/home.dart';
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
          if (details.primaryVelocity! > 0) {
            setState(() {
              _page = 0;
              unFocus(context);
            });
          } else {
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
                              'assets/icons/Medical Diagnosis System.png',
                              height: 200),
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
                              messageId = email = data.trim();
                            },
                          ),
                        ),
                        CustomTextField(
                          hintLabel: 'Password',
                          icon: Icons.password,
                          controller: controllerUserPassowrd,
                          onChanged: (data) {
                            password = data;
                          },
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("don't have an account?  "),
                              GestureDetector(
                                onTap: () {
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
                                await loginUser();
                                clearUserData();

                                // ignore: use_build_context_synchronously
                                showSnackBar(context,
                                    message: 'Sucsseed Login!',
                                    color: Colors.white);

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return const HomePage();
                                  }),
                                );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showSnackBar(context,
                                      message: 'User not found!',
                                      color: Colors.white);
                                } else if (e.code == 'wrong-password') {
                                  showSnackBar(context,
                                      message: 'Wrong password!',
                                      color: Colors.white);
                                } else {
                                  showSnackBar(context,
                                      message: e.toString(),
                                      color: Colors.white);
                                }
                              } catch (e) {
                                showSnackBar(context,
                                    message: e.toString(), color: Colors.white);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              showSnackBar(context,
                                  message: 'Error!', color: Colors.white);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
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
                              onPressed: () {},
                            ),
                            const SizedBox(width: 15),
                            IconAuth(
                              image: 'assets/icons/facebook.png',
                              onPressed: () {},
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
                              'assets/icons/Medical Diagnosis System.png',
                              height: 200),
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
                          child: CustomTextField(
                            hintLabel: 'Email',
                            icon: Icons.email,
                            controller: controllerDoctorEmail,
                            onChanged: (data) {
                              messageId = email = data.trim();
                            },
                          ),
                        ),
                        CustomTextField(
                          hintLabel: 'Password',
                          icon: Icons.password,
                          controller: controllerDoctorPassowrd,
                          onChanged: (data) {
                            password = data;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 51),
                        CustomButton(
                          buttonText: 'Login',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                // await loginUser();
                                // clearDoctorData();

                                // // ignore: use_build_context_synchronously
                                // showSnackBar(context,
                                //     message: 'Sucsseed Login!',
                                //     color: Colors.white);

                                // // ignore: use_build_context_synchronously
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) {
                                //     return HomePage();
                                //   }),
                                // );
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showSnackBar(context,
                                      message: 'User not found!',
                                      color: Colors.white);
                                } else if (e.code == 'wrong-password') {
                                  showSnackBar(context,
                                      message: 'Wrong password!',
                                      color: Colors.white);
                                } else {
                                  showSnackBar(context,
                                      message: e.toString(),
                                      color: Colors.white);
                                }
                              } catch (e) {
                                showSnackBar(context,
                                    message: e.toString(), color: Colors.white);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              showSnackBar(context,
                                  message: 'Error!', color: Colors.white);
                            }
                          },
                        ),
                        const SizedBox(height: 50)
                      ],
                    )),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  Future<void> loginDoctor() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
