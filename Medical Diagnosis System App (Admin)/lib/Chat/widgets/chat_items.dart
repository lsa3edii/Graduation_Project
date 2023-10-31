import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/custom_circle_avatar.dart';

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
