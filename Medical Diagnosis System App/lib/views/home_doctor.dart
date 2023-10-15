import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/models/users.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Chat/views/chat_page.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/icon_auth.dart';
import 'login_page.dart';
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
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
              setState(() {
                _page = value;
              });
            },
          ),
          body: _page == 0
              ? InteractiveViewer(
                  maxScale: 2,
                  child: Column(
                    children: [
                      const Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomContainer(),
                          Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 5),
                            child: Center(
                              child: CustomCircleAvatar(
                                image: kDoctorImage,
                                r1: 72,
                                r2: 70,
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
                                  maxLength: 12,
                                  hintLabel: 'Username',
                                  onChanged: (data) {},
                                ),
                              ),
                              const Center(
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Pacifico'),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                child: CustomTextField(
                                  icon: Icons.email,
                                  hintLabel: 'Email',
                                  onChanged: (data) {},
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Center(
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                      fontSize: 20, fontFamily: 'Pacifico'),
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                child: CustomTextField(
                                  icon: Icons.password,
                                  hintLabel: 'Password',
                                  obscureText: true,
                                  onChanged: (data) {},
                                ),
                              ),
                              const SizedBox(height: 30),
                              CustomButton(
                                buttonText: 'Update',
                                onPressed: () {},
                              ),
                              const SizedBox(height: 50),
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
                                        );
                                      },
                                    ),
                                    IconAuth(
                                      image: 'assets/icons/linkedin.png',
                                      onPressed: () async {
                                        await launchUrl(Uri.parse(
                                            'https://www.linkedin.com/in/muhammedabdulrahim'));
                                      },
                                    ),
                                    IconAuth(
                                      image: 'assets/icons/whatsapp.png',
                                      onPressed: () async {
                                        await launchUrl(
                                            Uri.parse(
                                                'https://wa.me/+2001098867501'),
                                            mode:
                                                LaunchMode.externalApplication);
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
              : StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection(kUsers).snapshots(),
                  builder: (context, snapshot) {
                    List<UserModel> users = [];

                    if (snapshot.hasData) {
                      for (int i = 0; i < snapshot.data!.docs.length; i++) {
                        users.add(UserModel.fromJson(snapshot.data!.docs[i]));
                        // print(users[i].email);
                      }
                      return Scrollbar(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, i) {
                            return ChatItem2(
                              buttonText: users[i].email.split('@')[0],
                              onPressed: () async {
                                chats
                                    .doc(users[i].email)
                                    .collection('${users[i].email}-Chat');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ChatPage(
                                      messageId: '${users[i].email}-doctor');
                                }));
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Chat List is Empty...',
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 25,
                            fontFamily: 'Pacifico',
                          ),
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
