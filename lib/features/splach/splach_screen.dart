import 'dart:async';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/core/storage/hive_helper.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:ahfaz_damanak/features/on_bourding/onBourding.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      bool? onBoarding = HiveHelper.getData(key: 'OnBoarding');
      String? token = HiveHelper.getData(key: 'api_token');

      if (onBoarding == true) {
        if (token != null) {
          Constants.navigateAndFinish(context, const MainScreen());
        } else {
          Constants.navigateAndFinish(context, const LoginScreen());
        }
      } else {
        Constants.navigateAndFinish(context, const OnBoarding());
      }
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
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          height: MediaQueryValue(context).heigh * 0.3,
          image: AssetImage(ImageAssets.logo),
        ),
      ),
    );
  }
}
