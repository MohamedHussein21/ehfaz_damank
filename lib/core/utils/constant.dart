import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../helper/cash_helper.dart';
import 'color_mange.dart';

enum ToastStates { success, error, warning }

class Constants {
  static void navigateTo(context, widget) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
      );

  static void navigateAndFinish(
    context,
    widget,
  ) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        (route) {
          return false;
        },
      );

  static void showToast({
    required String text,
    required ToastStates state,
  }) =>
      Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: chooseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0,
      );

  static Color chooseToastColor(ToastStates state) {
    Color color;

    switch (state) {
      case ToastStates.success:
        color = Colors.green;
        break;
      case ToastStates.error:
        color = Colors.red;
        break;
      case ToastStates.warning:
        color = Colors.amber;
        break;
    }

    return color;
  }

  static AppBar defaultAppBar(
    BuildContext context, {
    String? txt,
  }) {
    return AppBar(
      title: Text(
        txt!,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      toolbarHeight: 80,
      actions: [
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
            size: 20,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  static AppBar gradientAppBar({
    String? txt,
  }) {
    return AppBar(
      title: Text(
        txt!,
        style: TextStyle(color: ColorManger.wightColor),
      ),
      iconTheme: IconThemeData(color: ColorManger.wightColor),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4B5096),
              Color(0xff091A2B),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      toolbarHeight: 80,
    );
  }

  static const String baseUrl = '';
}

const defaultImage =
    'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?t=st=1650642518~exp=1650643118~hmac=0b7b8e50b2226fc9d468e5746126dab422b68123c63261be18e8cf420ebc2725&w=740';

String? uId = CashHelper.getData(key: 'uId');
