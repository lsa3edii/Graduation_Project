import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medical_diagnosis_system/constants.dart';
import 'package:photo_view/photo_view.dart';

class DisplyImage extends StatelessWidget {
  final File? img;
  final String image;

  const DisplyImage({super.key, required this.image, this.img});

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;

    if (img == null) {
      imageProvider = AssetImage(image);
    } else {
      imageProvider = FileImage(img!);
    }

    return Scaffold(
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
        imageProvider: imageProvider, // Replace with your image path
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}
