import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/contactUs/presentation/pages/contact_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/add_card.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("saved paid methods".tr(),
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(IconsAssets.payment,
                height: MediaQueryValue(context).heigh * 0.2),
            SizedBox(height: MediaQueryValue(context).heigh * 0.04),
            Text("There are no saved payment methods currently".tr(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: MediaQueryValue(context).heigh * 0.04),
            Text(
                "add your payment methods to make future payments easier and faster"
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: MediaQueryValue(context).heigh * 0.07),
            ElevatedButton(
              onPressed: () {
                Constants.navigateTo(context, ContactUsScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.defaultColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("contact us".tr(),
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
