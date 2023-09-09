import 'package:flutter/material.dart';
import '../constants.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double r1, r2;
  final String? image;
  final Color? borderColor;

  const CustomCircleAvatar(
      {super.key, this.image, this.r1 = 35, this.r2 = 33, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: r1,
      backgroundColor: borderColor ?? kPrimaryColor,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: r2,
        backgroundImage:
            AssetImage(image ?? 'assets/icons/Medical Diagnosis System.png'),
      ),
    );
  }
}
