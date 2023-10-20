import 'package:flutter/material.dart';
import '../constants.dart';

class CustomContainer extends StatelessWidget {
  final String? username;
  final int flag;

  const CustomContainer({super.key, this.username, this.flag = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          color: kPrimaryColor),
      child: flag == 0
          ? const SizedBox()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Hello',
                        style: TextStyle(
                            fontSize: 75,
                            color: kSecondaryColor,
                            fontStyle: FontStyle.italic)),
                    Container(
                      height: 75,
                      alignment: Alignment.bottomCenter,
                      child: Text(username ?? 'User',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            // fontStyle: FontStyle.italic,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: Text('Now you can use our online services for free !!',
                      style: TextStyle(fontSize: 20, color: Colors.grey[400])),
                ),
              ],
            ),
    );
  }
}
