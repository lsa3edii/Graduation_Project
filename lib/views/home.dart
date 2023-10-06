import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/views/ai_page.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'package:medical_diagnosis_system/widgets/custom_button.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:medical_diagnosis_system/widgets/custom_container.dart';
import '../../constants.dart';
import '../Chat/views/chat_page.dart';
import '../helper/helper_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        Image.asset('assets/images/neurology2.jpg'),
      ],
    ),
    Image.asset('assets/images/neurology.jpg'),
    Image.asset('assets/images/neurology1.jpg'),
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
                        unFocus(context);
                        showSnackBar(context,
                            message: 'LogOut!', color: Colors.white);
                        Navigator.pop(context);
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
                      const Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomContainer(),
                          Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 5),
                            child: Center(
                              child: CustomCircleAvatar(
                                image: 'assets/images/sa3edii.jpg',
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
                            children: const [
                              SizedBox(height: 150),
                              Center(
                                child: Text(
                                  'Settings',
                                  style: TextStyle(
                                      fontSize: 25, fontFamily: 'Pacifico'),
                                ),
                              ),
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
                                              'assets/animations/Animation - 1695398860329.json',
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
                              ChatItem(
                                buttonText: 'Dr. lSa3edii',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return SplashScreen(
                                        page: ChatPage(messageId: messageId!),
                                        animation:
                                            'assets/animations/Animation - 1695399264640.json',
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
