// import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/views/login_page.dart';
import 'package:medical_diagnosis_system/views/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MedicalDiagnosisSystem());
  // runApp(DevicePreview(builder: (context) => const MedicalDiagnosisSystem()));
}

class MedicalDiagnosisSystem extends StatelessWidget {
  const MedicalDiagnosisSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Medical Diagnosis System',
      color: kPrimaryColor,
      //   theme: ThemeData(
      //     brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        page: LoginPage(),
        animation: 'assets/animations/Animation - start.json',
        seconds: 3,
        flag: 1,
      ),
    );
  }
}
