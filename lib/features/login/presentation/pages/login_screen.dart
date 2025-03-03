import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/validator.dart';
import '../widgets/defaultFormField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Validations {
  @override
  Widget build(BuildContext context) {
    bool checkedValue = false;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryValue(context).toPadding * 0.9,
          vertical: MediaQueryValue(context).toPadding * 3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Image(
                height: MediaQueryValue(context).heigh * 0.1,
                image: AssetImage(ImageAssets.logo),
                color: ColorManger.defaultColor,
              ),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Center(
              child: Text(
                'Login'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text('Login Discription'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Text(
              'Phone Number'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            DefaultTextForm(
              isPassword: false,
              type: TextInputType.text,
              validate: (value) => phoneValidation(value),
              hint: 'Enter Phone Number'.tr(),
              hintStyle: TextStyle(color: ColorManger.grayColor),
              suffix: Image(image: AssetImage(ImageAssets.smartPhone)),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Text(
              'Password'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.start,
            ),
            DefaultTextForm(
              isPassword: false,
              type: TextInputType.text,
              validate: (value) => phoneValidation(value),
              hint: 'ُEnter Password'.tr(),
              hintStyle: TextStyle(color: ColorManger.grayColor),
              suffix: Image(image: AssetImage(ImageAssets.password)),
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'remember me'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Checkbox(
                  value: checkedValue,
                  onChanged: (value) {
                    setState(() {
                      checkedValue = true;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
