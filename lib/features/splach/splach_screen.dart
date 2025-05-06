import 'dart:async';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/on_bourding/onBourding.dart';
import 'package:flutter/material.dart';

import '../../core/utils/constant.dart';
import '../../core/utils/images_mange.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      Constants.navigateAndFinish(context, const OnBoarding());
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          height: MediaQueryValue(context).heigh * 0.3,
          image: AssetImage(ImageAssets.logo),
        ),
      ),
    );
  }
}
