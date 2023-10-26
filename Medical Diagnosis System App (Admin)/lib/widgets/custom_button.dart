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
  final Color? buttonColor;
  final Color? textColor;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final bool isEnabled;

  const CustomButton2({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.fontFamily,
    this.fontWeight,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(right: 50, left: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )
            // minimumSize: const Size(300, 50),
            ),
        onPressed: isEnabled ? onPressed : null,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20,
            color: textColor ?? kSecondaryColor,
            fontFamily: fontFamily ?? 'Pacifico',
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class CustomButton3 extends StatelessWidget {
  final Widget widget;
  final VoidCallback? onPressed;

  const CustomButton3(
      {super.key, required this.widget, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(shape: const CircleBorder()),
      onPressed: onPressed,
      child: widget,
    );
  }
}
