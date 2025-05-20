import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/forget_pass.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/images_mange.dart';
import '../cubit/login_cubit.dart';
import 'dart:ui' as ui;

class OtpScreenScreen extends StatefulWidget {
  final String phone;

  const OtpScreenScreen({super.key, required this.phone});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreenScreen> {
  String _otpCode = '';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('otp '.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageAssets.logo,
            height: media.height * 0.18,
          ),
          const SizedBox(height: 24),
          Text(
            '${'enter the verification code sent to'.tr()} ${widget.phone}',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: OtpTextField(
              numberOfFields: 4,
              borderColor: ColorManger.defaultColor,
              focusedBorderColor: ColorManger.defaultColor,
              showFieldAsBox: true,
              borderRadius: BorderRadius.circular(12),
              fieldWidth: 55,
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {
                _otpCode = verificationCode;
              },
            ),
          ),
          const SizedBox(height: 32),
          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is VerifyForgetPasswordSuccess) {
                Constants.navigateTo(
                  context,
                  ChangePasswordScreen(phone: widget.phone, otp: _otpCode),
                );
              } else if (state is VerifyForgetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              var cubit = LoginCubit.get(context);

              return DefaultButton(
                submit: () {
                  if (_otpCode.length == 4) {
                    cubit.verifyForgetPassword(
                      phone: widget.phone,
                      code: _otpCode,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('please enter full code'.tr())),
                    );
                  }
                },
                title: 'verify'.tr(),
                width: media.width * 0.8,
              );
            },
          ),
        ],
      ),
    );
  }
}
