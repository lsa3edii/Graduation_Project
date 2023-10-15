import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:medical_diagnosis_system/widgets/custom_circle_avatar.dart';

class ChatItem1 extends StatelessWidget {
  final String buttonText;
  final String? image;
  final VoidCallback? onPressed;

  const ChatItem1({
    super.key,
    required this.buttonText,
    this.image,
    required this.onPressed,
  });

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
            CustomCircleAvatar(
              image: image ?? 'assets/icons/Medical Diagnosis System.png',
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

class ChatItem2 extends StatelessWidget {
  final String buttonText;
  final String? image;
  final VoidCallback? onPressed;

  const ChatItem2({
    super.key,
    required this.buttonText,
    this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[100],
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            CustomCircleAvatar(
              image: image ?? 'assets/icons/Medical Diagnosis System.png',
              r1: 39,
              r2: 37,
              borderColor: kPrimaryColor,
            ),
            const SizedBox(width: 15),
            Text(
              buttonText,
              style: const TextStyle(
                  fontSize: 25, fontFamily: 'Pacifico', color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
