import 'package:flutter/material.dart';
import 'custom_circle_avatar.dart';
import '../constants.dart';

class UserItem extends StatelessWidget {
  final String buttonText;
  final String? image;
  final VoidCallback? onPressed;
  final int flag;

  const UserItem({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.image,
    this.flag = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3),
      height: 85,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            CustomCircleAvatar(
              image: image ?? kDefaultImage,
              r1: 35,
              r2: 33,
              borderColor: Colors.white,
              flag: flag,
              flag2: 1,
            ),
            const SizedBox(width: 15),
            Text(
              buttonText,
              style: const TextStyle(
                  fontSize: 25, fontFamily: 'Pacifico', color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
