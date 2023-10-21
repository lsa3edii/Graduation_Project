import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/models/users.dart';
import 'package:medical_diagnosis_system/views/disply_image.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
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
        return false;
      },
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
            actions: [
              Column(
                children: [
                  SizedBox(
                    height: 35,
                    width: 50,
                    child: IconButton(
                      onPressed: () {
                        AuthServices.logout();
                        clearUserData();
                        clearDoctorData();
                        unFocus(context);
                        showSnackBar(context, message: 'LogOut!');
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ));
                        }
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ),
                  const Text(
                    'LogOut',
                    style: TextStyle(fontSize: 12, fontFamily: 'Pacifico'),
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
              Icon(Icons.forum, color: Colors.white),
            ],
            onTap: (value) {
              Feedback.forTap(context);
              setState(() {
                _page = value;
              });
            },
          ),
          body: _page == 0
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
                                padding:
                                    const EdgeInsets.only(top: 40, bottom: 5),
                                child: Center(
                                  child: CustomButton3(
                                    widget: CustomCircleAvatar(
                                      // borderColor: Colors.white,
                                      image: kDoctorImage,
                                      img: img,
                                      r1: 72,
                                      r2: 70,
                                    ),
                                    onPressed: () {
                                      showSheet(
                                        context: context,
                                        choices: [
                                          'See Profile Picture',
                                          'Update Profile Picture',
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
                                                        image: kDoctorImage,
                                                        img: img),
                                              ),
                                            );
                                          } else {
                                            Navigator.pop(context);

                                            img = await pickImage(
                                                imageSource:
                                                    ImageSource.gallery,
                                                pickedFile: pickedFile);

                                            setState(() {});
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
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
                                          fontSize: 20, fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 65,
                                    child: CustomTextField(
                                      icon: Icons.person,
                                      controller: controllerUsernameDoctorHome,
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
                                          fontSize: 20, fontFamily: 'Pacifico'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 65,
                                    child: CustomTextField(
                                      icon: Icons.password,
                                      hintLabel: 'Password',
                                      controller: controllerPasswordDoctorHome,
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
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        try {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          AuthServices.createUserCollection(
                                            userCredential: userCredential!,
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
                                              message: 'Successfully updated!');
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
                    ),
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: users.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<UserModel> usersList = [];

                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        usersList
                            .add(UserModel.fromJson(snapshot.data!.docs[i]));
                        // print(usersList[i].email);
                      }
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
                        return Scrollbar(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: usersList.length,
                            itemBuilder: (context, i) {
                              chatId = usersList[i].email;
                              // print(i);
                              return chatId == user!.email
                                  ? null
                                  : ChatItem2(
                                      buttonText: chatId!.split('@')[0],
                                      onPressed: () async {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            chatId = usersList[i].email;
                                            // print(i);
                                            return ChatPage(
                                                appBarimage: kDefaultImage,
                                                appBarText:
                                                    chatId!.split('@')[0],
                                                messageId: '$chatId-doctor');

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
                            },
                          ),
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
                  }),
        ),
      ),
    );
  }
}
