import 'dart:io';
import 'package:flutter/material.dart';
import '../constants.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double r1, r2;
  final File? img;
  final String image;
  final Color? borderColor;
  final int flag;

  const CustomCircleAvatar({
    super.key,
    required this.image,
    this.img,
    this.r1 = 35,
    this.r2 = 33,
    this.borderColor,
    this.flag = 0,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> backgroundImage;

    if (flag == 1) {
      backgroundImage = NetworkImage(image);
    } else if (img == null) {
      backgroundImage = AssetImage(image);
    } else {
      backgroundImage = FileImage(img!);
    }

    return CircleAvatar(
      radius: r1,
      backgroundColor: borderColor ?? kPrimaryColor,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: r2,
        backgroundImage: backgroundImage,
      ),
    );
  }
}
