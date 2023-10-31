import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system_admin/views/signup_page.dart';
import 'package:medical_diagnosis_system_admin/widgets/custom_button.dart';
import 'package:medical_diagnosis_system_admin/widgets/custom_circle_avatar.dart';
import '../helper/helper_functions.dart';
import '../constants.dart';
import '../services/auth_services.dart';

class ManageUsers extends StatefulWidget {
  final String email;
  final String username;
  final String? image;

  const ManageUsers({
    super.key,
    required this.email,
    required this.username,
    this.image,
  });

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Medical Diagnosis System',
          style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 30),
          Center(
            child: CustomCircleAvatar(
              borderColor: kPrimaryColor,
              image: widget.image ?? kDefaultImage,
              r1: 111,
              r2: 107,
              flag: widget.image == null ? 0 : 1,
              flag3: 1,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            indent: 25,
            endIndent: 25,
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Text(
              'Email : ${widget.email}',
              style: const TextStyle(
                  fontSize: 27, color: kPrimaryColor, fontFamily: 'Pacifico'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            child: Text(
              'Username : ${widget.username}',
              style: const TextStyle(
                  fontSize: 27, color: kPrimaryColor, fontFamily: 'Pacifico'),
            ),
          ),
          const Divider(
            indent: 25,
            endIndent: 25,
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 35),
          CustomButton2(
            buttonText: 'Delete Account',
            buttonColor: Colors.red[700],
            fontFamily: '',
            fontWeight: FontWeight.bold,
            textColor: Colors.white,
            onPressed: widget.email == user!.email
                ? null
                : () {
                    showDeletionDialog(
                      context: context,
                      flag: 1,
                      onPressed: () async {
                        await AuthServices.deleteAccount(
                            email: widget.email, flag: 0);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        showSnackBar(context, message: 'Account deleted..!');
                      },
                    );
                  },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
