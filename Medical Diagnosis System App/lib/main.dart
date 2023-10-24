import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/views/login_page.dart';
import 'package:medical_diagnosis_system/views/signup_user_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import 'package:medical_diagnosis_system/views/home_doctor.dart';
import 'package:medical_diagnosis_system/views/home_user.dart';
import 'firebase_options.dart';
import 'helper/helper_functions.dart';
import 'models/users.dart';
// import 'package:device_preview/device_preview.dart';

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

class MedicalDiagnosisSystem extends StatefulWidget {
  const MedicalDiagnosisSystem({super.key});

  @override
  State<MedicalDiagnosisSystem> createState() => _MedicalDiagnosisSystemState();
}

class _MedicalDiagnosisSystemState extends State<MedicalDiagnosisSystem> {
  Future<void> _loadUserRole() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      chatId = user!.email;

      userRole = await AuthServices.retrieveUserData(
        uid: user!.uid,
        userCredential: userCredential,
        userField: UserFields.userRole,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(const AssetImage('assets/images/neurology2.jpg'), context);
    return MaterialApp(
      title: 'Medical Diagnosis System',
      color: kPrimaryColor,
      //   theme: ThemeData(
      //     brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        // page: LoginPage(),
        page: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                if (user != null) {
                  if (user!.emailVerified && userRole == userRole1) {
                    return const UserHomePage();
                  } else if (/* user!.emailVerified && */ userRole ==
                      userRole2) {
                    return const DoctorHomePage();
                  } else {
                    return const LoginPage();
                  }
                } else {
                  return const LoginPage();
                }
              } else {
                return const LoginPage();
              }
            } else {
              return const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Please Wait...',
                      style: TextStyle(
                        fontSize: 30,
                        color: kPrimaryColor,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                      backgroundColor: Colors.grey,
                    ),
                  ],
                ),
              );
            }
          },
        ),
        animation: 'assets/animations/Animation - start.json',
        seconds: 3,
        flag: 0,
      ),
    );
  }
}
