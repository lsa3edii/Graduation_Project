import 'dart:io';
import 'dart:async';
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
            if (flag == 1)
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
          ],
        );
      },
    );
  }
}
