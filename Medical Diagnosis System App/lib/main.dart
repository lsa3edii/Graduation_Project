// import 'package:device_preview/device_preview.dart';
// import 'package:medical_diagnosis_system/views/home_user.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/views/login_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'firebase_options.dart';
import 'helper/helper_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MedicalDiagnosisSystem());
  // runApp(DevicePreview(builder: (context) => const MedicalDiagnosisSystem()));
}

class MedicalDiagnosisSystem extends StatelessWidget {
  const MedicalDiagnosisSystem({super.key});

  @override
  Widget build(BuildContext context) {
    // precacheImage(const AssetImage('assets/images/neurology2.jpg'), context);
    return const MaterialApp(
      title: 'Medical Diagnosis System',
      color: kPrimaryColor,
      //   theme: ThemeData(
      //     brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        page: LoginPage(),
        // page: StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.hasData) {
        //         return const UserHomePage();
        //       } else {
        //         return const LoginPage();
        //       }
        //     } else {
        //       return const Center(
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(
        //               'Please Wait...',
        //               style: TextStyle(
        //                 fontSize: 30,
        //                 color: kPrimaryColor,
        //                 fontFamily: 'Pacifico',
        //               ),
        //             ),
        //             CircularProgressIndicator(
        //               color: kPrimaryColor,
        //               backgroundColor: Colors.grey,
        //             ),
        //           ],
        //         ),
        //       );
        //     }
        //   },
        // ),
        animation: 'assets/animations/Animation - start.json',
        seconds: 3,
        flag: 0,
      ),
    );
  }
}
