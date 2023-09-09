import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/Chat/widgets/chat_items.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
  // GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: WillPopScope(
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
              // setState(() {
              //   isLoading = true;
              // });
              // await Future.delayed(const Duration(seconds: 1));
              setState(() {
                _page = 2;
                //   isLoading = false;
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
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                  color: kPrimaryColor),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 40, bottom: 5),
                              child: Center(
                                child: CustomCircleAvatar(
                                  image: 'assets/images/sa3edii.jpeg',
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
                                SizedBox(height: 550),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : _page == 1
                    ? const Center(
                        child: Text(
                          'Home',
                          style:
                              TextStyle(fontSize: 25, fontFamily: 'Pacifico'),
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Image.asset('assets/images/doctorChat.jpg'),
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
                            padding: EdgeInsets.only(right: 50, left: 50),
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
                                  return ChatPage(messageId: messageId!);
                                },
                              ));
                            },
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
