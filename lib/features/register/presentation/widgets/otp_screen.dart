import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/images_mange.dart';
import '../../../login/presentation/pages/login_screen.dart';
import '../../../login/presentation/widgets/defauldButton.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQueryValue(context).toPadding * 0.9,
          vertical: MediaQueryValue(context).toPadding * 3,
        ),
        child: Column(children: [
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
              'Confirm Number Phone'.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Text('sent Otp'.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          SizedBox(height: MediaQueryValue(context).heigh * 0.06),
          OtpTextField(
            fieldWidth: MediaQueryValue(context).width * 0.14,
            borderRadius: BorderRadius.circular(10),
            numberOfFields: 5,
            borderColor: Color(0xFF512DA8),
            showFieldAsBox: true,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) {}, // end onSubmit
          ),
          SizedBox(height: MediaQueryValue(context).heigh * 0.1),
          DefaultButton(
            title: 'Confirm'.tr(),
            submit: () {
              Constants.navigateTo(context, MainScreen());
            },
            width: MediaQueryValue(context).width * 0.9,
          ),
          SizedBox(height: MediaQueryValue(context).heigh * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'The code was not sent.!!'.tr(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                  onPressed: () {
                    Constants.navigateTo(context, LoginScreen());
                  },
                  child: Text(
                    'Sent Agin'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))
            ],
          ),
        ]),
      ),
    );
  }
}
