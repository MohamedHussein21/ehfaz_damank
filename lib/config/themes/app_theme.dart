import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/color_mange.dart';
import '../../core/utils/font_mange.dart';

ThemeData appTheme() {
  return ThemeData(
    scaffoldBackgroundColor: ColorManger.wightColor,
    fontFamily: FontFamily.fontFamily,
    primaryColor: ColorManger.defaultColor,
    appBarTheme: AppBarTheme(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManger.wightColor,
            statusBarIconBrightness: Brightness.dark),
        backgroundColor: ColorManger.wightColor,
        elevation: 0,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ColorManger.blackColor),
        iconTheme: IconThemeData(color: ColorManger.wightColor, size: 25)),
    iconTheme: IconThemeData(color: ColorManger.defaultColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorManger.defaultColor),
    primaryIconTheme: IconThemeData(color: ColorManger.defaultColor),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle: TextStyle(color: ColorManger.defaultColor),
        unselectedLabelStyle: TextStyle(color: ColorManger.grayColor),
        unselectedIconTheme: IconThemeData(color: ColorManger.grayColor),
        selectedIconTheme: IconThemeData(color: ColorManger.defaultColor)),
  );
}
