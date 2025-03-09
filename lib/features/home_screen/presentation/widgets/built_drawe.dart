import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../../../conect_us/conect_us.dart';
import '../../../payment/presentation/pages/payment_screen.dart';
import '../../../plans/presentation/pages/plans_screen.dart';
import '../../../profileScreen/presentation/pages/profile_screen.dart';

class BuiltDrawe extends StatelessWidget {
  const BuiltDrawe({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQueryValue(context).width * 0.75,
      backgroundColor: ColorManger.wightColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorManger.defaultColor,
            ),
            accountName: Text(
              "Mohamed Huusein",
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text("01011780085"),
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.profile)),
            title: Text("إعدادات الحساب"),
            onTap: () {
              Constants.navigateTo(context, ProfileScreen());
            },
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.note)),
            title: Text("التذكيرات "),
            onTap: () {},
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.star)),
            title: Text("ترقية الحساب"),
            onTap: () {
              Constants.navigateTo(context, UpgradeAccountScreen());
            },
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.card)),
            title: Text("طرق الدفع المحفوظة"),
            onTap: () {
              Constants.navigateTo(context, PaymentMethodsScreen());
            },
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.invoice)),
            title: Text("عن حفظ فواتيرك"),
            onTap: () {},
          ),
          Divider(
            height: 0.1,
          ),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.call)),
            title: Text("تواصل معنا"),
            onTap: () {
              Constants.navigateTo(context, ContactUsScreen());
            },
          ),
          Divider(),
          ListTile(
            leading: Image(image: AssetImage(IconsAssets.elements)),
            title: Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
