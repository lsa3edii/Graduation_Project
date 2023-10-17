import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
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
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../Chat/views/chat_page.dart';
import '../helper/helper_functions.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _page = 1;
  bool isLoading = false;

  List<Widget> images = [
    Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 3),
        const SizedBox(
          width: 155,
          child: Text(
            'Enter your brain MRI (magnetic resonance imaging) image and our AI system will help you to detect if you have disease or are healthy. Click on Get Started now !',
            style: TextStyle(
                fontSize: 19,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        Image.asset('assets/images/neurology2.jpg', cacheHeight: 300),
      ],
    ),
    Image.asset('assets/images/neurology.jpg', cacheHeight: 300),
    Image.asset('assets/images/neurology1.jpg', cacheHeight: 300),
  ];

  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onHorizontalDragEnd: (details) async {
          if (details.primaryVelocity! > 0 && _page == 1) {
            setState(() {
              _page = 0;
            });
          } else if (details.primaryVelocity! < 0 && _page == 0) {
            setState(() {
              _page = 1;
            });
          } else if (details.primaryVelocity! < 0 && _page == 1) {
            setState(() {
              _page = 2;
            });
          } else if (details.primaryVelocity! > 0 && _page == 2) {
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
              Icon(Icons.home, color: Colors.white),
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const CustomContainer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 5),
                            child: Center(
                              child: CustomButton3(
                                widget: const CustomCircleAvatar(
                                  borderColor: Colors.white,
                                  image: 'assets/images/sa3edii.jpg',
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
                                    onTap: () {},
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
                                  maxLength: 12,
                                  hintLabel: 'Username',
                                  onChanged: (data) {},
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
                                height: 45,
                                child: CustomTextField(
                                  icon: Icons.password,
                                  hintLabel: 'Password',
                                  obscureText: true,
                                  onChanged: (data) {},
                                ),
                              ),
                              const SizedBox(height: 30),
                              CustomButton2(
                                buttonText: 'Update',
                                fontFamily: '',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                onPressed: () {},
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
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                    ),
                                    IconAuth(
                                      image: 'assets/icons/linkedin.png',
                                      onPressed: () async {
                                        await launchUrl(
                                            Uri.parse(
                                                'https://www.linkedin.com/in/muhammedabdulrahim'),
                                            mode:
                                                LaunchMode.externalApplication);
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
              : _page == 1
                  ? Column(
                      children: [
                        const CustomContainer(flag: 1),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ImageSlideshow(
                                height: 315,
                                indicatorRadius: 5,
                                indicatorColor: kPrimaryColor,
                                isLoop: true,
                                children: images,
                              ),
                              const SizedBox(height: 57),
                              CustomButton2(
                                  buttonText: 'Get Started',
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
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
                    )
                  : FutureBuilder(
                      future: Future.delayed(const Duration(milliseconds: 300)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child:
                                CircularProgressIndicator(color: kPrimaryColor),
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
                                buttonText: 'Dr. lSa3edii',
                                image: kDoctorImage,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
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
      ),
    );
  }
}
