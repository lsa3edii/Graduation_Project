import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_diagnosis_system_admin/Chat/views/chat_page.dart';
import 'package:medical_diagnosis_system_admin/views/manage_users.dart';
import 'package:medical_diagnosis_system_admin/views/signup_page.dart';
import 'package:medical_diagnosis_system_admin/widgets/user_items.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'disply_image.dart';
import 'login_page.dart';
import '../helper/helper_functions.dart';
import '../models/users.dart';
import '../services/auth_services.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_circle_avatar.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';
import '../../constants.dart';

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
  String? appBarText;
  String? userId;
  String? localUsername;
  GlobalKey<FormState> formKey = GlobalKey();
  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Widget> slides = [
    Lottie.asset('assets/animations/Animation - signup0.json'),
    Lottie.asset('assets/animations/Animation - signup1.json'),
    Image.asset('assets/images/addUser.jpg', cacheHeight: 300),
  ];

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;
    chatId = user?.email;

    return WillPopScope(
      onWillPop: () async {
        return await handleOnWillPop(context: context);
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) async {
          if (details.primaryVelocity! > 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 0;
              appBarText = null;
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
              appBarText = null;
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! < 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 2;
              appBarText = null;
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! > 0 && _page == 2) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
              appBarText = null;
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! > 0 && _page == 3) {
            Feedback.forTap(context);
            setState(() {
              _page = 2;
              appBarText = null;
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! < 0 && _page == 2) {
            Feedback.forTap(context);
            setState(() {
              _page = 3;
              appBarText = 'DOCTOR';
              controllerSearch.clear();
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
                        controllerSearch.clear();

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
            title: appBarText == null
                ? const Text(
                    'Medical Diagnosis System',
                    style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
                  )
                : Row(
                    children: [
                      const CustomCircleAvatar(
                        image: kDoctorImage,
                        r1: 25,
                        r2: 23,
                        borderColor: kSecondaryColor,
                      ),
                      const SizedBox(width: 15),
                      Text(
                        appBarText!,
                        style: const TextStyle(
                          fontSize: 27,
                          fontFamily: 'Pacifico',
                          color: kSecondaryColor,
                        ),
                      ),
                    ],
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

              if (value == 3) {
                appBarText = 'DOCTOR';
              } else {
                appBarText = null;
              }

              setState(() {
                _page = value;
                if (_page != 2) controllerSearch.clear();
              });
            },
          ),
          body: Stack(
            children: [
              LiquidPullToRefresh(
                color: kPrimaryColor,
                animSpeedFactor: 10,
                showChildOpacityTransition: false,
                onRefresh: () async {
                  controllerSearch.clear();
                  clearAdminData();
                  showSnackBar(context, message: 'Refresh..');
                  setState(() {});
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: _page == 0
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
                                              future:
                                                  AuthServices.retrieveImage(
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
                                                      image: image ??
                                                          kDefaultImage,
                                                      img: img,
                                                      r1: 72,
                                                      r2: 70,
                                                      flag: flag,
                                                      flag4: 1,
                                                    ),
                                                    onPressed: () {
                                                      showSheet(
                                                        context: context,
                                                        choices: [
                                                          'See Profile Picture',
                                                          'Change Profile Picture',
                                                        ],
                                                        onChoiceSelected:
                                                            (i) async {
                                                          if (i == 0) {
                                                            // to pop bottom sheet
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    DisplyImage(
                                                                        image: image ??
                                                                            kDefaultImage,
                                                                        img:
                                                                            img,
                                                                        flag:
                                                                            flag),
                                                              ),
                                                            );
                                                          } else {
                                                            Navigator.pop(
                                                                context);

                                                            img =
                                                                await pickImage(
                                                              imageSource:
                                                                  ImageSource
                                                                      .gallery,
                                                              pickedFile:
                                                                  pickedFile,
                                                            );

                                                            AuthServices
                                                                .uploadImage(
                                                              email:
                                                                  user!.email!,
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
                                          physics:
                                              const BouncingScrollPhysics(),
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

                                                    AuthServices
                                                        .createUserCollection(
                                                      userCredential:
                                                          userCredential!,
                                                      email: email!,
                                                      password: password,
                                                      userRole: userRole3,
                                                      username: username,
                                                    );

                                                    await userCredential!.user!
                                                        .updatePassword(
                                                            password!);

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
                                                    image:
                                                        'assets/icons/github.png',
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
                                      padding: const EdgeInsets.only(
                                          top: 40, bottom: 5),
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
                                                builder: (context) =>
                                                    DisplyImage(
                                                  image: user!.photoURL!
                                                      .replaceAll(
                                                          "s96-c", "s400-c"),
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
                                            isEnabled: false,
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
                                                await AuthServices
                                                    .deleteAccount(
                                                  flag: 1,
                                                );
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
                                                  // ignore: use_build_context_synchronously
                                                  unFocus(context);
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
                                                  // ignore: use_build_context_synchronously
                                                  unFocus(context);
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
                                                  // ignore: use_build_context_synchronously
                                                  unFocus(context);
                                                },
                                              ),
                                              IconAuth(
                                                image:
                                                    'assets/icons/github.png',
                                                onPressed: () async {
                                                  await launchUrl(Uri.parse(
                                                      'https://github.com/lsa3edii'));
                                                  // ignore: use_build_context_synchronously
                                                  unFocus(context);
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
                              if (AuthServices
                                  .isUserAuthenticatedWithGoogle()) {
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
                                  CustomContainer(
                                      username: localUsername, flag: 1),
                                  const SizedBox(height: 5),
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        ImageSlideshow(
                                          height: 315,
                                          indicatorRadius: 5,
                                          indicatorColor: kPrimaryColor,
                                          isLoop: true,
                                          children: slides,
                                          onPageChanged: (value) {
                                            Feedback.forTap(context);
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        CustomButton2(
                                          buttonText: 'Add User',
                                          textColor: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: '',
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return SignupPage(
                                                  operationType: 'Add User',
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
                                        const SizedBox(height: 10),
                                        CustomButton2(
                                          buttonText: 'Add Doctor',
                                          textColor: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: '',
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return SignupPage(
                                                  operationType: 'Add Doctor',
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
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : _page == 2
                            ? StreamBuilder<QuerySnapshot>(
                                stream: users.snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<UserModel> usersList = [];
                                    List<UserModel> filteredUsersList;

                                    for (int i = 0;
                                        i < snapshot.data!.docs.length;
                                        i++) {
                                      usersList.add(
                                        UserModel.fromJson(
                                            snapshot.data!.docs[i]),
                                      );
                                      // print(usersList[i].email);
                                    }
                                    filteredUsersList = usersList;

                                    if (usersList.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Users List is Empty...',
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 25,
                                            fontFamily: 'Pacifico',
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Manage Users',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          CustomTextFieldForSearch(
                                            onChanged: (data) {
                                              setState(() {
                                                filteredUsersList =
                                                    usersList.where((user) {
                                                  return user.email
                                                      .contains(data);
                                                }).toList();
                                              });
                                              print(filteredUsersList[0].email);
                                              print(filteredUsersList.length);
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: Scrollbar(
                                              child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    filteredUsersList.length,
                                                itemBuilder: (context, i) {
                                                  userId = filteredUsersList[i]
                                                      .email;

                                                  return userId ==
                                                          '' // solve it later
                                                      ? null
                                                      : FutureBuilder<String?>(
                                                          future: AuthServices
                                                              .retrieveImage(
                                                                  email:
                                                                      userId),
                                                          builder: (context,
                                                              snapshot) {
                                                            String? image;
                                                            int flag = 0;

                                                            if (snapshot
                                                                .hasData) {
                                                              image =
                                                                  snapshot.data;
                                                              flag = 1;
                                                            } else {
                                                              flag = 0;
                                                            }
                                                            return UserItem(
                                                              image: image,
                                                              flag: flag,
                                                              buttonText:
                                                                  filteredUsersList[
                                                                          i]
                                                                      .email
                                                                      .split(
                                                                          '@')[0],
                                                              onPressed:
                                                                  () async {
                                                                unFocus(
                                                                    context);
                                                                controllerSearch
                                                                    .clear();

                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      userId = filteredUsersList[
                                                                              i]
                                                                          .email;
                                                                      return FutureBuilder<
                                                                          String?>(
                                                                        future: AuthServices.retrieveUserData2(
                                                                            email:
                                                                                userId!,
                                                                            field:
                                                                                UserFields.username),
                                                                        builder:
                                                                            (context,
                                                                                snapshot) {
                                                                          String
                                                                              username =
                                                                              'User';
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            username =
                                                                                snapshot.data!;
                                                                          }
                                                                          return ManageUsers(
                                                                            email:
                                                                                filteredUsersList[i].email,
                                                                            username:
                                                                                username,
                                                                            image:
                                                                                image?.replaceAll("s96-c", "s400-c"),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  } else {
                                    return const Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Please Wait... ',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 25,
                                              fontFamily: 'Pacifico',
                                            ),
                                          ),
                                          CircularProgressIndicator(
                                              color: kPrimaryColor,
                                              backgroundColor: Colors.grey)
                                        ],
                                      ),
                                    );
                                  }
                                },
                              )
                            : ChatPage(chatId: chatId!),
              ),
              _page == 0 || _page == 1
                  ? Positioned(
                      top: 3,
                      right: 3,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isDarkMode = !isDarkMode;
                          });
                        },
                        icon: isDarkMode
                            ? const Icon(Icons.light_mode,
                                size: 30, color: Colors.white)
                            : const Icon(Icons.dark_mode,
                                size: 30, color: Colors.white),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
