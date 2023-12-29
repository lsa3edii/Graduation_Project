import 'package:flutter/material.dart';
import '../constants.dart';
import '../views/signup_user_page.dart';

final TextEditingController controllerUserEmail = TextEditingController();
final TextEditingController controllerUserPassowrd = TextEditingController();

final TextEditingController controllerDoctorEmail = TextEditingController();
final TextEditingController controllerDoctorPassowrd = TextEditingController();

final TextEditingController controllerUsernameSignUP = TextEditingController();
final TextEditingController controllerEmailSignUP = TextEditingController();
final TextEditingController controllerPasswordSignUP = TextEditingController();
final TextEditingController controllerConfirmPasswordSignUP =
    TextEditingController();

final TextEditingController controllerUsernameUserHome =
    TextEditingController();
final TextEditingController controllerPasswordUserHome =
    TextEditingController();

final TextEditingController controllerUsernameDoctorHome =
    TextEditingController();
final TextEditingController controllerPasswordDoctorHome =
    TextEditingController();

final TextEditingController controllerChat = TextEditingController();
final TextEditingController controllerNLP = TextEditingController();
final TextEditingController controllerSearch = TextEditingController();

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String? hintLabel;
  final dynamic icon;
  final Function(String data)? onChanged;
  final TextEditingController? controller;
  final int? maxLines;
  final int? maxLength;
  final bool showVisibilityToggle;
  final bool isEnabled;
  final bool isNLPText;
  bool obscureText;

  CustomTextField({
    super.key,
    required this.onChanged,
    this.icon,
    this.controller,
    this.hintLabel,
    this.maxLines,
    this.maxLength,
    this.obscureText = false,
    this.isEnabled = true,
    this.isNLPText = false,
    this.showVisibilityToggle = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        // autofocus: true,
        // onSubmitted: (data) {},
        onTap: () => Feedback.forTap(context),
        validator: (data) {
          if (data!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
        controller: widget.controller ?? TextEditingController(),
        onChanged: widget.onChanged,
        maxLines: widget.maxLines ?? 1,
        maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        enabled: widget.isEnabled,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: widget.hintLabel ?? 'Enter a text',
          label: Text(
            widget.hintLabel ?? '',
            style: const TextStyle(color: kPrimaryColor),
          ),
          suffix:
              widget.isNLPText ? Icon(widget.icon, color: kPrimaryColor) : null,
          prefixIcon: !widget.isNLPText
              ? Icon(
                  widget.icon,
                  color: kPrimaryColor,
                )
              : null,
          suffixIcon: widget.showVisibilityToggle
              ? IconButton(
                  icon: Icon(!widget.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: kPrimaryColor,
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField2 extends StatefulWidget {
  final String? hintLabel;
  final dynamic icon;
  final Function(String data)? onChanged;
  final TextEditingController? controller;
  final bool showVisibilityToggle;
  bool obscureText;

  CustomTextField2(
      {super.key,
      required this.onChanged,
      this.icon,
      this.controller,
      this.hintLabel,
      this.obscureText = false,
      this.showVisibilityToggle = false});

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        // autofocus: true,
        // onSubmitted: (data) {},
        onTap: () => Feedback.forTap(context),
        validator: (data) {
          if (data!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
        controller: widget.controller ?? TextEditingController(),
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: widget.hintLabel ?? 'Enter a text',
          label: Text(
            widget.hintLabel ?? '',
            style: const TextStyle(color: kPrimaryColor),
          ),
          prefixIcon: Icon(widget.icon, color: kPrimaryColor),
          suffixIcon: widget.showVisibilityToggle
              ? IconButton(
                  icon: Icon(!widget.obscureText
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: kPrimaryColor,
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextFieldForCheckPassword extends StatefulWidget {
  final String hintLabel;
  final dynamic icon;
  final Function(String data)? onChanged;
  final TextEditingController? controller;
  bool obscureText;

  CustomTextFieldForCheckPassword({
    super.key,
    required this.hintLabel,
    required this.onChanged,
    this.icon,
    this.controller,
    this.obscureText = false,
  });

  @override
  State<CustomTextFieldForCheckPassword> createState() =>
      _CustomTextFieldForCheckPasswordState();
}

class _CustomTextFieldForCheckPasswordState
    extends State<CustomTextFieldForCheckPassword> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onTap: () => Feedback.forTap(context),
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
        controller: widget.controller ?? TextEditingController(),
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          hintText: widget.hintLabel,
          label: Text(
            widget.hintLabel,
            style: const TextStyle(color: kPrimaryColor),
          ),
          prefixIcon: Icon(widget.icon, color: kPrimaryColor),
          suffixIcon: IconButton(
            icon: Icon(
                !widget.obscureText ? Icons.visibility : Icons.visibility_off),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldForChat extends StatelessWidget {
  final Function(String data)? onChanged;
  final Function(String data)? onSubmitted;
  final VoidCallback? onPressed;
  final VoidCallback? cameraOnPressed;
  final VoidCallback? galleryOnPressed;

  const CustomTextFieldForChat({
    super.key,
    required this.onChanged,
    required this.onSubmitted,
    required this.onPressed,
    required this.cameraOnPressed,
    required this.galleryOnPressed,
  });

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
                onTap: () => Feedback.forTap(context),
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
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 30,
                        child: IconButton(
                          onPressed: galleryOnPressed,
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.image,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: cameraOnPressed,
                          splashRadius: 20,
                          icon: const Icon(
                            Icons.camera,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
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

class CustomTextFieldForSearch extends StatelessWidget {
  final Function(String data)? onChanged;

  const CustomTextFieldForSearch({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: TextField(
          onTap: () => Feedback.forTap(context),
          controller: controllerSearch,
          onChanged: onChanged,
          enabled: true,
          decoration: InputDecoration(
            hintText: 'Search',
            label: const Text(
              'Search',
              style: TextStyle(color: kPrimaryColor),
            ),
            prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: kPrimaryColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
          ),
          style: const TextStyle(fontSize: 17),
        ),
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
