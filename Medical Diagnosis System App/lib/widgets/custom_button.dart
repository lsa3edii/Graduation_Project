import 'package:flutter/material.dart';
import '../constants.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;

  const CustomButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor, minimumSize: const Size(300, 50)),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final Color? color;
  final String? fontFamily;

  const CustomButton2({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.color,
    this.fontFamily,
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
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 20,
              color: color ?? kSecondaryColor,
              fontFamily: fontFamily ?? 'Pacifico'),
        ),
      ),
    );
  }
}
