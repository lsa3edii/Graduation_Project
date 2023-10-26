import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_diagnosis_system_admin/services/auth_services.dart';
import 'package:medical_diagnosis_system_admin/views/home_admin.dart';
import 'package:medical_diagnosis_system_admin/views/login_page.dart';
import 'package:medical_diagnosis_system_admin/views/signup_page.dart';
import 'package:medical_diagnosis_system_admin/views/splash_screen.dart';
import 'constants.dart';
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
  runApp(const MedicalDiagnosisSystemAdmin());
  // runApp(DevicePreview(builder: (context) => const MedicalDiagnosisSystem()));
}

class MedicalDiagnosisSystemAdmin extends StatefulWidget {
  const MedicalDiagnosisSystemAdmin({super.key});

  @override
  State<MedicalDiagnosisSystemAdmin> createState() =>
      _MedicalDiagnosisSystemAdminState();
}

class _MedicalDiagnosisSystemAdminState
    extends State<MedicalDiagnosisSystemAdmin> {
  Future<void> _loadUserRole() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
    return MaterialApp(
      title: 'MDS Admin',
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
                  if (user!.emailVerified && userRole == userRole3) {
                    return const AdminHomePage();
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
