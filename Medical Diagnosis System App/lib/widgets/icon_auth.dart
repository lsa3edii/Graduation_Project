import 'package:flutter/material.dart';

class IconAuth extends StatelessWidget {
  final String image;
  final VoidCallback onPressed;

  const IconAuth({super.key, required this.image, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(image, cacheHeight: 75, cacheWidth: 75),
      ),
    );
  }
}
