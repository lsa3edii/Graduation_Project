import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/services/auth_services.dart';
import '../constants.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double r1, r2;
  final File? img;
  final String image;
  final Color? borderColor;
  final int flag;
  final int flag2;
  final int flag3;

  const CustomCircleAvatar({
    super.key,
    required this.image,
    this.img,
    this.r1 = 35,
    this.r2 = 33,
    this.borderColor,
    this.flag = 0,
    this.flag2 = 0,
    this.flag3 = 0,
  });

  Future<bool> _imageLoaded() async {
    if (flag == 1) {
      final completer = Completer<bool>();
      final imageStream = NetworkImage(image).resolve(ImageConfiguration.empty);

      imageStream.addListener(ImageStreamListener(
        (info, synchronousCall) {
          completer.complete(true);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          completer.completeError(exception, stackTrace);
        },
      ));

      return completer.future;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? backgroundImage;

    if (flag == 1) {
      backgroundImage = NetworkImage(image);
    } else if (img == null) {
      backgroundImage = AssetImage(image);
    } else {
      backgroundImage = FileImage(img!);
    }

    return FutureBuilder<Object>(
      future: _imageLoaded(),
      builder: (context, snapshot) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: r1,
              backgroundColor: borderColor ?? kPrimaryColor,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: r2,
                backgroundImage: backgroundImage,
              ),
            ),
            if (flag == 1 && flag2 == 0)
              if (snapshot.hasError)
                const Icon(Icons.error)
              else if (snapshot.connectionState == ConnectionState.waiting)
                Positioned(
                  top: 55,
                  right: 55,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    backgroundColor: Colors.blueGrey[200],
                  ),
                ),
            if (flag2 == 1)
              if (snapshot.hasError)
                const Icon(Icons.error)
              else if (snapshot.connectionState == ConnectionState.waiting)
                Positioned(
                  top: 25,
                  right: 22,
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                      backgroundColor: Colors.blueGrey[200],
                    ),
                  ),
                ),
            if (!AuthServices.isUserAuthenticatedWithGoogle() && flag3 == 1)
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.add_a_photo, color: kPrimaryColor),
              ),
          ],
        );
      },
    );
  }
}
