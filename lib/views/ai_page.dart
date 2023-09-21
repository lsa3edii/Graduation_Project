import 'package:flutter/material.dart';
import '../constants.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A',
              style: TextStyle(fontSize: 32, color: kSecondaryColor),
            ),
            Text(
              'I Page',
              style: TextStyle(
                  fontSize: 27, color: kSecondaryColor, fontFamily: 'Pacifico'),
            ),
          ],
        ),
      ),
      // body: ,
    );
  }
}
