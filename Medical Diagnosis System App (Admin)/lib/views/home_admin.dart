import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_diagnosis_system_admin/views/signup_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/helper_functions.dart';
import '../models/users.dart';
import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_circle_avatar.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';
import '../../constants.dart';
import 'disply_image.dart';
import 'login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  File? img;
  dynamic pickedFile;
  int _page = 1;
  bool isLoading = false;
  String? localUsername;
  GlobalKey<FormState> formKey = GlobalKey();

  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) async {
          if (details.primaryVelocity! > 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 0;
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
            });
          } else if (details.primaryVelocity! < 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 2;
            });
          } else if (details.primaryVelocity! > 0 && _page == 2) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
            });
          } else if (details.primaryVelocity! > 0 && _page == 3) {
            Feedback.forTap(context);
            setState(() {
              _page = 2;
            });
          } else if (details.primaryVelocity! < 0 && _page == 2) {
            Feedback.forTap(context);
            setState(() {
              _page = 3;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              Column(
                children: [
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: IconButton(
                      onPressed: () async {
                        await AuthServices.logout();

                        clearAdminData();
                        clearSignUpDataAdmin();
                        clearSignUpDataUser();
                        clearSignUpDataDoctor();

                        // ignore: use_build_context_synchronously
                        unFocus(context);
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, message: 'LogOut!');
                        // ignore: use_build_context_synchronously
                        if (Navigator.canPop(context)) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        }
                      },
                      icon: const Icon(Icons.logout),
                      color: kSecondaryColor,
                    ),
                  ),
                  const Text(
                    'LogOut',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Pacifico',
                      color: kSecondaryColor,
                    ),
                  )
                ],
              ),
            ],
            automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: const Text(
              'Medical Diagnosis System',
              style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
            ),
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: _page,
            height: 55,
            letIndexChange: (index) => true,
            animationDuration: const Duration(milliseconds: 300),
            color: kPrimaryColor,
            backgroundColor: Colors.white,
            items: const <Widget>[
              Icon(Icons.settings, color: Colors.white),
              Icon(Icons.home, color: Colors.white),
              Icon(Icons.people, color: Colors.white),
              Icon(Icons.forum, color: Colors.white),
            ],
            onTap: (value) {
              Feedback.forTap(context);
              clearAdminData();
              setState(() {
                _page = value;
              });
            },
          ),
          body: _page == 0
              ? !AuthServices.isUserAuthenticatedWithGoogle()
                  ? ModalProgressHUD(
                      inAsyncCall: isLoading,
                      child: Form(
                        key: formKey,
                        child: InteractiveViewer(
                          maxScale: 2,
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const CustomContainer(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40, bottom: 5),
                                    child: FutureBuilder<String?>(
                                        future: AuthServices.retrieveImage(
                                            email: user?.email),
                                        builder: (context, snapshot) {
                                          int flag = 0;
                                          String? image;

                                          if (snapshot.hasData) {
                                            image = snapshot.data;
                                            flag = 1;
                                          } else {
                                            flag = 0;
                                          }
                                          return Center(
                                            child: CustomButton3(
                                              widget: CustomCircleAvatar(
                                                borderColor: Colors.white,
                                                image: image ?? kDefaultImage,
                                                img: img,
                                                r1: 72,
                                                r2: 70,
                                                flag: flag,
                                                flag3: 1,
                                              ),
                                              onPressed: () {
                                                showSheet(
                                                  context: context,
                                                  choices: [
                                                    'See Profile Picture',
                                                    'Change Profile Picture',
                                                  ],
                                                  onChoiceSelected: (i) async {
                                                    if (i == 0) {
                                                      // to pop bottom sheet
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DisplyImage(
                                                                  image: image ??
                                                                      kDefaultImage,
                                                                  img: img,
                                                                  flag: flag),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.pop(context);

                                                      img = await pickImage(
                                                        imageSource:
                                                            ImageSource.gallery,
                                                        pickedFile: pickedFile,
                                                      );

                                                      AuthServices.uploadImage(
                                                        email: user!.email!,
                                                        img: img,
                                                      );

                                                      setState(() {});
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Scrollbar(
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Username',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Pacifico'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 65,
                                        child: CustomTextField(
                                          icon: Icons.person,
                                          controller:
                                              controllerUsernameAdminHome,
                                          maxLength: 12,
                                          hintLabel: 'Username',
                                          onChanged: (data) {
                                            localUsername =
                                                username = data.trim();
                                          },
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          'Password',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Pacifico'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 65,
                                        child: CustomTextField(
                                          icon: Icons.password,
                                          hintLabel: 'Password',
                                          controller:
                                              controllerPasswordAdminHome,
                                          maxLength: 25,
                                          obscureText: true,
                                          showVisibilityToggle: true,
                                          onChanged: (data) {
                                            password = data;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      CustomButton2(
                                        buttonText: 'Update',
                                        fontFamily: '',
                                        fontWeight: FontWeight.bold,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            try {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              AuthServices.createUserCollection(
                                                userCredential: userCredential!,
                                                email: email!,
                                                password: password,
                                                userRole: userRole3,
                                                username: username,
                                              );

                                              await userCredential!.user!
                                                  .updatePassword(password!);

                                              // ignore: use_build_context_synchronously
                                              unFocus(context);
                                              clearAdminData();

                                              // ignore: use_build_context_synchronously
                                              showSnackBar(context,
                                                  message:
                                                      'Successfully updated!');
                                            } catch (e) {
                                              showSnackBar(context,
                                                  message: e.toString());
                                            }
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      CustomButton2(
                                        buttonText: 'Delete Account',
                                        buttonColor: Colors.red[700],
                                        fontFamily: '',
                                        fontWeight: FontWeight.bold,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          showDeletionDialog(
                                            context: context,
                                            onPressed: () async {
                                              await AuthServices
                                                  .deleteAccount();
                                              await AuthServices.logout();

                                              clearAdminData();
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              // ignore: use_build_context_synchronously
                                              unFocus(context);
                                              // ignore: use_build_context_synchronously
                                              showSnackBar(context,
                                                  message:
                                                      'Account deleted.. logout!');
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 35),
                                      const Divider(
                                        indent: 25,
                                        endIndent: 25,
                                        thickness: 1,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 5),
                                      const Center(
                                        child: Text(
                                          'Contact The Developer :',
                                          style: TextStyle(
                                              fontSize: 27,
                                              color: kPrimaryColor,
                                              fontFamily: 'Pacifico'),
                                        ),
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconAuth(
                                              image:
                                                  'assets/icons/facebook.png',
                                              onPressed: () async {
                                                await launchUrl(
                                                    Uri.parse(
                                                        'https://www.facebook.com/MuhammedAbdulrahim0'),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                            ),
                                            IconAuth(
                                              image:
                                                  'assets/icons/linkedin.png',
                                              onPressed: () async {
                                                await launchUrl(
                                                    Uri.parse(
                                                        'https://www.linkedin.com/in/muhammedabdulrahim'),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                            ),
                                            IconAuth(
                                              image:
                                                  'assets/icons/whatsapp.png',
                                              onPressed: () async {
                                                await launchUrl(
                                                    Uri.parse(
                                                        'https://wa.me/+2001098867501'),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              },
                                            ),
                                            IconAuth(
                                              image: 'assets/icons/github.png',
                                              onPressed: () async {
                                                await launchUrl(Uri.parse(
                                                    'https://github.com/lsa3edii'));
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : InteractiveViewer(
                      maxScale: 2,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const CustomContainer(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 5),
                                child: Center(
                                  child: CustomButton3(
                                    widget: CustomCircleAvatar(
                                      borderColor: Colors.white,
                                      image: user!.photoURL!
                                          .replaceAll("s96-c", "s400-c"),
                                      img: img,
                                      r1: 72,
                                      r2: 70,
                                      flag: 1,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DisplyImage(
                                            image: user!.photoURL!
                                                .replaceAll("s96-c", "s400-c"),
                                            img: img,
                                            flag: 1,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Scrollbar(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  const Center(
                                    child: Text(
                                      'Username',
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 65,
                                    child: CustomTextField(
                                      icon: Icons.person,
                                      controller: controllerUsernameAdminHome,
                                      isEnabled: false,
                                      maxLength: 12,
                                      hintLabel: 'Username',
                                      onChanged: (data) {
                                        localUsername = username = data.trim();
                                      },
                                    ),
                                  ),
                                  const Center(
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                          fontSize: 20, fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 65,
                                    child: CustomTextField(
                                      icon: Icons.password,
                                      hintLabel: 'Password',
                                      controller: controllerPasswordAdminHome,
                                      isEnabled: false,
                                      maxLength: 25,
                                      obscureText: true,
                                      showVisibilityToggle: true,
                                      onChanged: (data) {
                                        password = data;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const CustomButton2(
                                    buttonText: 'Update',
                                    isEnabled: false,
                                    fontFamily: '',
                                    fontWeight: FontWeight.bold,
                                    textColor: Colors.white,
                                    onPressed: null,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomButton2(
                                    buttonText: 'Delete Account',
                                    buttonColor: Colors.red[700],
                                    fontFamily: '',
                                    fontWeight: FontWeight.bold,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      showDeletionDialog(
                                        context: context,
                                        onPressed: () async {
                                          await AuthServices.deleteAccount();
                                          await AuthServices.logout();

                                          clearAdminData();
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context);
                                          // ignore: use_build_context_synchronously
                                          unFocus(context);
                                          // ignore: use_build_context_synchronously
                                          showSnackBar(context,
                                              message:
                                                  'Account deleted.. logout!');
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 35),
                                  const Divider(
                                    indent: 25,
                                    endIndent: 25,
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 5),
                                  const Center(
                                    child: Text(
                                      'Contact The Developer :',
                                      style: TextStyle(
                                          fontSize: 27,
                                          color: kPrimaryColor,
                                          fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconAuth(
                                          image: 'assets/icons/facebook.png',
                                          onPressed: () async {
                                            await launchUrl(
                                                Uri.parse(
                                                    'https://www.facebook.com/MuhammedAbdulrahim0'),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                        ),
                                        IconAuth(
                                          image: 'assets/icons/linkedin.png',
                                          onPressed: () async {
                                            await launchUrl(
                                                Uri.parse(
                                                    'https://www.linkedin.com/in/muhammedabdulrahim'),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                        ),
                                        IconAuth(
                                          image: 'assets/icons/whatsapp.png',
                                          onPressed: () async {
                                            await launchUrl(
                                                Uri.parse(
                                                    'https://wa.me/+2001098867501'),
                                                mode: LaunchMode
                                                    .externalApplication);
                                          },
                                        ),
                                        IconAuth(
                                          image: 'assets/icons/github.png',
                                          onPressed: () async {
                                            await launchUrl(Uri.parse(
                                                'https://github.com/lsa3edii'));
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 50),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
              : _page == 1
                  ? FutureBuilder<String?>(
                      future: AuthServices.retrieveUserData(
                        uid: user?.uid,
                        userCredential: userCredential,
                        userField: UserFields.username,
                      ),
                      builder: (context, snapshot) {
                        if (AuthServices.isUserAuthenticatedWithGoogle()) {
                          AuthServices.uploadImage2(
                            email: user!.email!,
                            photoURL: user!.photoURL!,
                          );
                        }
                        if (snapshot.hasData) {
                          // localUsername to load username faster in UI
                          localUsername = username = snapshot.data;
                        } else {
                          username = null;
                        }
                        return Column(
                          children: [
                            CustomContainer(username: localUsername, flag: 1),
                            const SizedBox(height: 5),
                            Expanded(
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  const SizedBox(height: 150),
                                  CustomButton2(
                                    buttonText: 'Add User',
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: '',
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return SignupPage(
                                            userType: 'Add User',
                                            buttonText: 'Add User',
                                            controllerUsernameSignUP:
                                                controllerUsernameUserSignUP,
                                            controllerEmailSignUP:
                                                controllerEmailUserSignUP,
                                            controllerPasswordSignUP:
                                                controllerPasswordUserSignUP,
                                            controllerConfirmPasswordSignUP:
                                                controllerConfirmPasswordUserSignUP,
                                          );
                                        },
                                      ));
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomButton2(
                                    buttonText: 'Add Doctor',
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: '',
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return SignupPage(
                                            userType: 'Add Doctor',
                                            buttonText: 'Add Doctor',
                                            controllerUsernameSignUP:
                                                controllerUsernameDoctorSignUP,
                                            controllerEmailSignUP:
                                                controllerEmailDoctorSignUP,
                                            controllerPasswordSignUP:
                                                controllerPasswordDoctorSignUP,
                                            controllerConfirmPasswordSignUP:
                                                controllerConfirmPasswordDoctorSignUP,
                                          );
                                        },
                                      ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      })
                  : _page == 2
                      ? const Center(
                          child: Text('Manage Users',
                              style: TextStyle(
                                  fontSize: 25, fontFamily: 'Pacifico')),
                        )
                      : const Center(
                          child: Text('Chat',
                              style: TextStyle(
                                  fontSize: 25, fontFamily: 'Pacifico')),
                        ),
        ),
      ),
    );
  }
}
