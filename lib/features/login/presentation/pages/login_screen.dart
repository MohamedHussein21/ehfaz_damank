import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:ahfaz_damanak/features/register/presentation/pages/register_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/validator.dart';
import '../../../main/presentation/pages/main_screen.dart';
import '../widgets/defaultFormField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Validations {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryValue(context).toPadding * 0.9,
          vertical: MediaQueryValue(context).toPadding * 3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Login Discription'.tr(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Text('Phone Number'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.end),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            DefaultTextForm(
                isPassword: false,
                type: TextInputType.text,
                validate: (value) => phoneValidation(value),
                hint: 'Enter Phone Number'.tr(),
                hintStyle: TextStyle(color: ColorManger.darkColor),
                prefix: Image(image: AssetImage(ImageAssets.smartPhone))),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Text(
              'Password'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            DefaultTextForm(
                isPassword: false,
                type: TextInputType.text,
                validate: (value) => phoneValidation(value),
                hint: 'Enter Password'.tr(),
                hintStyle: TextStyle(color: ColorManger.darkColor),
                prefix: Image(image: AssetImage(ImageAssets.password))),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text('remember me'.tr(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            DefaultButton(
                title: 'Login'.tr(),
                submit: () {
                  Constants.navigateTo(context, MainScreen());
                },
                width: MediaQueryValue(context).width * 0.9),
            SizedBox(height: MediaQueryValue(context).heigh * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?".tr()),
                TextButton(
                    onPressed: () {
                      Constants.navigateTo(context, RegisterScreen());
                    },
                    child: Text('Sign Up'.tr())),
              ],
            )
          ],
        ),
      ),
    );
  }
}
