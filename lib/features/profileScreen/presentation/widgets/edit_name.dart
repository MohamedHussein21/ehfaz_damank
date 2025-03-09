import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';

class EditNameScreen extends StatelessWidget {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();

  EditNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات الحساب")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Constants.buildTextField(
                'الاسم الاول ', firstController, 'mohamed'),
            SizedBox(height: MediaQueryValue(context).heigh * 0.03),
            Constants.buildTextField(
                'اسم  العائلة ', lastController, 'hussein'),
            SizedBox(height: MediaQueryValue(context).heigh * 0.05),
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
