import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:photo_view/photo_view.dart';

class DisplyImage extends StatelessWidget {
  final File? img;
  final String image;
  final int flag;

  const DisplyImage({super.key, required this.image, this.img, this.flag = 0});

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;

    if (flag == 1) {
      imageProvider = NetworkImage(image);
    } else if (img == null) {
      imageProvider = AssetImage(image);
    } else {
      imageProvider = FileImage(img!);
    }

    return GestureDetector(
      // onVerticalDragEnd: (details) {
      //   Feedback.forTap(context);

      //   if (details.primaryVelocity! > 0) {
      //     Navigator.pop(context);
      //   } else if (details.primaryVelocity! < 0) {
      //     Navigator.pop(context);
      //   }
      // },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: const Text(
            'Medical Diagnosis System',
            style: TextStyle(fontSize: 27, fontFamily: 'Pacifico'),
          ),
        ),
        backgroundColor: Colors.white,
        body: PhotoView(
          imageProvider: imageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
