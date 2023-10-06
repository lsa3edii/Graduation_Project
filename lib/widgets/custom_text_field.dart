import 'package:flutter/material.dart';
import '../constants.dart';
import '../views/signup_user_page.dart';

TextEditingController controllerUserEmail = TextEditingController();
TextEditingController controllerUserPassowrd = TextEditingController();

TextEditingController controllerDoctorEmail = TextEditingController();
TextEditingController controllerDoctorPassowrd = TextEditingController();

TextEditingController controllerChat = TextEditingController();

class CustomTextField extends StatelessWidget {
  final String? hintLabel;
  final dynamic icon;
  final Function(String data)? onChanged;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.onChanged,
    this.controller,
    this.hintLabel,
    this.maxLines,
    this.maxLength,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        // autofocus: true,
        validator: (data) {
          if (data!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
        // onSubmitted: (data) {},
        controller: controller ?? TextEditingController(),
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: hintLabel ?? 'Enter a text',
          label: Text(
            hintLabel ?? '',
            style: const TextStyle(color: kPrimaryColor),
          ),
          suffix: Icon(icon),
        ),
      ),
    );
  }
}

class CustomTextFieldForCheckPassword extends StatelessWidget {
  final String hintLabel;
  final dynamic icon;
  final Function(String data)? onChanged;
  final bool obscureText;

  const CustomTextFieldForCheckPassword(
      {super.key,
      required this.hintLabel,
      required this.icon,
      required this.onChanged,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        validator: (data) {
          if (data!.isEmpty) {
            return 'Field is required';
          }

          if (confirmPassword != password) {
            return "confirm password dosen't match password";
          }
          return null;
        },
        // onSubmitted: (data) {},
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: hintLabel,
          label: Text(
            hintLabel,
            style: const TextStyle(color: kPrimaryColor),
          ),
          suffix: Icon(icon),
        ),
      ),
    );
  }
}

class CustomTextFieldForChat extends StatelessWidget {
  final Function(String data)? onChanged;
  final Function(String data)? onSubmitted;
  final VoidCallback? onPressed;

  const CustomTextFieldForChat(
      {super.key,
      required this.onChanged,
      required this.onSubmitted,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 7),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: controllerChat,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                decoration: InputDecoration(
                  label: const Text('  Message',
                      style: TextStyle(color: kPrimaryColor)),
                  hintText: 'Enter your message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: kPrimaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
                  // suffix: GestureDetector(
                  //   onTap: onTap,
                  //   child: Icon(Icons.send, color: Colors.blue[900]),
                  // ),
                ),
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.send,
              color: Colors.blue[900],
            ),
            splashRadius: 25,
          )
        ],
      ),
    );
  }
}

// class CustomTextFieldForConfirmPassword extends StatelessWidget {
//   String hintLabel;
//   dynamic icon;
//   Function(String data)? onChanged;
//   String? checkPassword;

//   CustomTextFieldForConfirmPassword({
//     super.key,
//     required this.hintLabel,
//     required this.icon,
//     required this.onChanged,
//     confirmPass,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: TextFormField(
//         // autofocus: true,
//         controller: confirmPass,
//         validator: (data) {
//           if (data!.isEmpty) {
//             return 'Field is required';
//           }

//           if (data != pass.toString()) {
//             return "password dosen't match confirm password";
//           }
//         },
//         onChanged: onChanged,
//         // onSubmitted: (data) {},
//         decoration: InputDecoration(
//           contentPadding:
//               const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//           border: const OutlineInputBorder(),
//           focusedBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: kPrimaryColor)),
//           hintText: hintLabel,
//           label: Text(
//             hintLabel,
//             style: const TextStyle(color: kPrimaryColor),
//           ),
//           suffix: Icon(icon),
//         ),
//       ),
//     );
//   }
// }
