import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/views/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MedicalDiagnosisSystem());
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
      home: LoginPage(),
    );
  }
}
