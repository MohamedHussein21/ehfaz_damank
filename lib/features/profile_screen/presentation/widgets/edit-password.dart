import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';

class EditPasswordScreen extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  EditPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات الحساب")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Constants.buildTextField(
                'كلمة السر ', passwordController, '******  '),
            Constants.buildTextField(
                ' تأكيد كلمة السر ', confirmPasswordController, '******  '),
            SizedBox(height: MediaQueryValue(context).heigh * 0.07),
            SizedBox(
              width: MediaQueryValue(context).width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.defaultColor,
                  side: BorderSide(color: ColorManger.defaultColor),
                  foregroundColor: ColorManger.wightColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("تحديث"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
