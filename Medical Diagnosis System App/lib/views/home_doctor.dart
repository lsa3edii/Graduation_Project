import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/models/users.dart';
import 'package:medical_diagnosis_system/views/ai_page.dart';
import 'package:medical_diagnosis_system/views/disply_image.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import '../Chat/views/chat_page.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';
import '../widgets/custom_circle_avatar.dart';
import '../widgets/custom_container.dart';
import '../helper/helper_functions.dart';
import '../services/auth_services.dart';
import '../constants.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  File? img;
  dynamic pickedFile;
  bool isLoading = false;
  int _page = 1;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: () async {
        return await handleOnWillPop(context: context);
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0 && _page == 1) {
            Feedback.forTap(context);
            setState(() {
              _page = 0;
              unFocus(context);
              controllerSearch.clear();
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            Feedback.forTap(context);
            setState(() {
              _page = 1;
              unFocus(context);
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
                        clearUserData();
                        clearDoctorData();
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
            title: const Text(
              'Medical Diagnosis System',
              style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
            ),
          ),
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            children: [
              CurvedNavigationBar(
                index: _page,
                height: 55,
                letIndexChange: (index) => true,
                animationDuration: const Duration(milliseconds: 300),
                color: kPrimaryColor,
                backgroundColor: Colors.white,
                items: const <Widget>[
                  Icon(Icons.settings, color: Colors.white),
                  Icon(Icons.forum, color: Colors.white),
                ],
                onTap: (value) {
                  Feedback.forTap(context);
                  setState(() {
                    _page = value;
                    if (_page == 0) controllerSearch.clear();
                  });
                },
              ),
              Positioned.fill(
                top: -30,
                child: Center(
                  child: CustomButton4(
                    widget: const Text(
                      'AI',
                      style: TextStyle(
                        fontSize: 25,
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const SplashScreen(
                            page: AIPage(),
                            animation: 'assets/animations/Animation - ai.json',
                            flag: 1,
                          );
                        },
                      ));
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              LiquidPullToRefresh(
                color: kPrimaryColor,
                animSpeedFactor: 10,
                showChildOpacityTransition: false,
                onRefresh: () async {
                  controllerSearch.clear();
                  clearDoctorData();
                  showSnackBar(context, message: 'Refresh..');
                  setState(() {});
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: _page == 0
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
                                      child: StreamBuilder<String?>(
                                        stream: AuthServices.retrieveImage(
                                                email: user?.email)
                                            .asStream(),
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
                                                // borderColor: Colors.white,
                                                image: image ?? kDoctorImage,
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
                                                                      kDoctorImage,
                                                                  img: img,
                                                                  flag: flag),
                                                        ),
                                                      );
                                                    } else {
                                                      Navigator.pop(context);

                                                      img = await pickImage(
                                                          imageSource:
                                                              ImageSource
                                                                  .gallery,
                                                          pickedFile:
                                                              pickedFile);

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
                                        },
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
                                                controllerUsernameDoctorHome,
                                            maxLength: 12,
                                            hintLabel: 'Username',
                                            onChanged: (data) {
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
                                                controllerPasswordDoctorHome,
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
                                                  userRole: userRole2,
                                                  username: username,
                                                );

                                                await userCredential!.user!
                                                    .updatePassword(password!);

                                                // ignore: use_build_context_synchronously
                                                unFocus(context);
                                                clearDoctorData();

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
                                          isEnabled: false,
                                          fontFamily: '',
                                          fontWeight: FontWeight.bold,
                                          textColor: Colors.white,
                                          onPressed: null,
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
                          ),
                        ),
                      )
                    : StreamBuilder<QuerySnapshot>(
                        stream: users.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<UserModel> usersList = [];
                            List<UserModel> filteredUsersList;

                            for (int i = 0;
                                i < snapshot.data!.docs.length;
                                i++) {
                              usersList.add(
                                  UserModel.fromJson(snapshot.data!.docs[i]));
                              // print(usersList[i].email);
                            }
                            filteredUsersList = usersList;

                            if (usersList.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Chats List is Empty...',
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
                                  const SizedBox(height: 10),
                                  CustomTextFieldForSearch(
                                    onChanged: (data) {
                                      setState(() {
                                        filteredUsersList =
                                            usersList.where((user) {
                                          return user.email.contains(data);
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
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: filteredUsersList.length,
                                        itemBuilder: (context, i) {
                                          chatId = filteredUsersList[i].email;

                                          return chatId ==
                                                  '' // user?.email -> solve it later
                                              ? null
                                              : FutureBuilder<String?>(
                                                  future: AuthServices
                                                      .retrieveImage(
                                                          email: chatId),
                                                  builder: (context, snapshot) {
                                                    String? image;
                                                    int flag = 0;

                                                    if (snapshot.hasData) {
                                                      image = snapshot.data;
                                                      flag = 1;
                                                    } else {
                                                      flag = 0;
                                                    }
                                                    return ChatItem2(
                                                        image: image,
                                                        flag: flag,
                                                        buttonText:
                                                            filteredUsersList[i]
                                                                .email
                                                                .split('@')[0],
                                                        onPressed: () async {
                                                          unFocus(context);
                                                          controllerSearch
                                                              .clear();

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                            builder: (context) {
                                                              chatId =
                                                                  filteredUsersList[
                                                                          i]
                                                                      .email;
                                                              return ChatPage(
                                                                appBarimage:
                                                                    image ??
                                                                        kDefaultImage,
                                                                appBarText:
                                                                    chatId!.split(
                                                                        '@')[0],
                                                                messageId:
                                                                    '$chatId-doctor',
                                                                flag: flag,
                                                              );

                                                              // // temporary solution
                                                              // if (i == 0) {
                                                              //   chatId = usersList[0].email;
                                                              //   return ChatPage(
                                                              //       appBarimage: kDefaultImage,
                                                              //       appBarText: chatId!.split('@')[0],
                                                              //       messageId: '$chatId-doctor');
                                                              // } else if (i == 1) {
                                                              //   chatId = usersList[1].email;
                                                              //   return ChatPage(
                                                              //       appBarimage: kDefaultImage,
                                                              //       appBarText: chatId!.split('@')[0],
                                                              //       messageId: '$chatId-doctor');
                                                              // } else {
                                                              //   chatId = usersList[2].email;
                                                              //   return ChatPage(
                                                              //       appBarimage: kDefaultImage,
                                                              //       appBarText: chatId!.split('@')[0],
                                                              //       messageId: '$chatId-doctor');
                                                              // }
                                                            },
                                                          ));
                                                        });
                                                  });
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
                          // if (snapshot.connectionState == ConnectionState.waiting) {
                          //   return const Center(
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         Text(
                          //           'Please Wait... ',
                          //           style: TextStyle(
                          //             color: kPrimaryColor,
                          //             fontSize: 25,
                          //             fontFamily: 'Pacifico',
                          //           ),
                          //         ),
                          //         CircularProgressIndicator(
                          //           color: kPrimaryColor,
                          //           backgroundColor: Colors.grey,
                          //         ),
                          //       ],
                          //     ),
                          //   );
                          // }
                        },
                      ),
              ),
              _page == 0
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
                                  size: 30, color: Colors.white)),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
