import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final Widget page;
  final String animation;
  final int seconds;
  final int flag;

  const SplashScreen({
    super.key,
    required this.page,
    required this.animation,
    this.seconds = 3,
    this.flag = 0,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void playSound() {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/hospital-sound.mp3'));
  }

  void start() {
    Timer(Duration(seconds: widget.seconds), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget.page),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    start();
    if (widget.flag == 1) {
      playSound();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          widget.animation,
          // frameRate: FrameRate(100),
        ),
      ),
    );
  }
}
