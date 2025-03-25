import 'dart:ffi';

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

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    massage, {
    required BuildContext scaffoldContext,
    required String text,
    required Color color,
  }) =>
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: color,
      ));

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

  static Future<dynamic> defaultDialog(
      {required BuildContext context,
      String? image,
      String? title,
      List<Widget>? action}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorManger.wightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Image(image: AssetImage(image!)),
              const SizedBox(height: 10),
              Text(
                title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
          actions: action,
        );
      },
    );
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
              .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: ColorManger.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  static buildTextFormField(
      String label, TextEditingController controller, String hint,
      {int? maxLine,
      TextInputType? keyboardType,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLine,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: validator,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  static buildTextField(
      String label, TextEditingController controller, String hint,
      {int? maxLine}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLine,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
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

String? token = CashHelper.getData(key: 'api_token');
