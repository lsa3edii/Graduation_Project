import 'dart:io';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import 'package:medical_diagnosis_system/views/ai_page.dart';
import 'package:medical_diagnosis_system/views/login_page.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'package:medical_diagnosis_system/widgets/custom_button.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:medical_diagnosis_system/widgets/custom_container.dart';
import 'package:medical_diagnosis_system/widgets/custom_text_field.dart';
import 'package:medical_diagnosis_system/widgets/icon_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'disply_image.dart';
import '../../constants.dart';
import '../Chat/views/chat_page.dart';
import '../helper/helper_functions.dart';
import '../models/users.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  File? img;
  dynamic pickedFile;
  int _page = 1;
  bool isLoading = false;
  String? localUsername;
  GlobalKey<FormState> formKey = GlobalKey();
  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  List<Widget> slides = [
    Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10, right: 15, left: 15),
          child: Text(
            'Enter your brain MRI (magnetic resonance imaging) image and our AI system will help you to detect if you have disease or are healthy. Click on get started now !',
            style: TextStyle(
                fontSize: 19,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        Lottie.asset('assets/animations/Animation - brain0.json'),
      ],
    ),
    Lottie.asset('assets/animations/Animation - brain1.json'),
    Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Lottie.asset('assets/animations/Animation - brain2.json'),
    ),
    Lottie.asset('assets/animations/Animation - brain3.json'),
    Image.asset('assets/images/neurology.jpg', cacheHeight: 300),
  ];

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser;

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
              Icon(Icons.forum, color: Colors.white),
            ],
            onTap: (value) {
              Feedback.forTap(context);
              clearUserData();
              setState(() {
                _page = value;
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
                  clearUserData();
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
                                                    image:
                                                        image ?? kDefaultImage,
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
                                                                      img: img,
                                                                      flag:
                                                                          flag),
                                                            ),
                                                          );
                                                        } else {
                                                          Navigator.pop(
                                                              context);

                                                          img = await pickImage(
                                                            imageSource:
                                                                ImageSource
                                                                    .gallery,
                                                            pickedFile:
                                                                pickedFile,
                                                          );

                                                          AuthServices
                                                              .uploadImage(
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
                                                    controllerUsernameUserHome,
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
                                                    controllerPasswordUserHome,
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
                                                      userRole: userRole1,
                                                      username: username,
                                                    );

                                                    await userCredential!.user!
                                                        .updatePassword(
                                                            password!);

                                                    // ignore: use_build_context_synchronously
                                                    unFocus(context);
                                                    clearUserData();

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

                                                    clearUserData();
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
                                                controllerUsernameUserHome,
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
                                                controllerPasswordUserHome,
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
                                                    .deleteAccount();
                                                await AuthServices.logout();

                                                clearUserData();
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
                                          height: 325,
                                          indicatorRadius: 5,
                                          indicatorColor: kPrimaryColor,
                                          isLoop: true,
                                          children: slides,
                                          onPageChanged: (value) {
                                            Feedback.forTap(context);
                                          },
                                        ),
                                        const SizedBox(height: 43),
                                        CustomButton2(
                                            buttonText: 'Get Started',
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return const SplashScreen(
                                                    page: AIPage(),
                                                    animation:
                                                        'assets/animations/Animation - ai.json',
                                                    flag: 1,
                                                  );
                                                },
                                              ));
                                            }),
                                        const SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            })
                        : FutureBuilder(
                            future: Future.delayed(
                                const Duration(milliseconds: 300)),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      color: kPrimaryColor),
                                ); // Show loading indicator
                              } else {
                                return ListView(
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    Container(
                                      height: 315,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xffEFFAFF),
                                            Color(0xffCDEEFF),
                                            Color(0xffC2EBFF)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/images/doctorChat.jpg',
                                        cacheHeight: 315,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Center(
                                      child: Text(
                                        'Chat with a Special Doctor',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: kPrimaryColor,
                                          fontFamily: 'Pacifico',
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          top: 5, right: 50, left: 50),
                                      child: Text(
                                        'You can chat with a doctor now for responding on your questions and inquiries.',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: kPrimaryColor,
                                          fontFamily: 'Pacifico',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    ChatItem1(
                                      buttonText: 'DOCTOR',
                                      image: kDoctorImage,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return SplashScreen(
                                              page: ChatPage(
                                                  appBarimage: kDoctorImage,
                                                  messageId: chatId!),
                                              animation:
                                                  'assets/animations/Animation - chat.json',
                                              flag: 2,
                                            );
                                          },
                                        ));
                                      },
                                    ),
                                    const SizedBox(height: 50),
                                  ],
                                );
                              }
                            },
                          ),
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
