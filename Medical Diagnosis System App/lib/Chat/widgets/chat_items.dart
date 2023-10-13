import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';

class ChatItem extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const ChatItem(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
            // minimumSize: const Size(300, 50),
            ),
        onPressed: onPressed,
        child: Row(
          children: [
            const CustomCircleAvatar(
              image: 'assets/icons/Medical Diagnosis System.png',
              r1: 22,
              r2: 20,
              borderColor: kSecondaryColor,
            ),
            const SizedBox(width: 25),
            Text(
              buttonText,
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'Pacifico', color: kSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
