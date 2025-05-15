import 'dart:developer';

import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/cubit/login_cubit.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/validator.dart';
import '../pages/login_screen.dart';
import '../widgets/defaultFormField.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;
  const ChangePasswordScreen(
      {super.key, required this.phone, required this.otp});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with Validations {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            Constants.navigateTo(context, const LoginScreen());
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
              appBar: AppBar(
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
              body: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryValue(context).toPadding * 1.2,
                  vertical: MediaQueryValue(context).toPadding * 1.5,
                ),
                child: Form(
                  key: loginKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Language change button in top right corner
                        Center(
                          child: Image(
                            height: MediaQueryValue(context).heigh * 0.2,
                            image: AssetImage(ImageAssets.logo),
                          ),
                        ),
                        Center(
                          child: Text(
                            "new password".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: ColorManger.blackColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                        Text(
                          "new password description".tr(),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 14,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: MediaQueryValue(context).heigh * 0.02),

                        // Phone number field

                        AutofillGroup(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Password'.tr(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  ),
                                ],
                              ),
                              DefaultTextForm(
                                aoutofillHints: [AutofillHints.password],
                                controller: passwordController,
                                isPassword: true,
                                type: TextInputType.visiblePassword,
                                validate: (value) => passwordValidation(value),
                                hint: 'Enter Password'.tr(),
                                hintStyle:
                                    TextStyle(color: ColorManger.darkColor),
                                prefix: Image(
                                    image: AssetImage(ImageAssets.password)),
                              ),
                              SizedBox(
                                  height:
                                      MediaQueryValue(context).heigh * 0.01),

                              // Password field
                              Row(
                                children: [
                                  Text(
                                    "confirm password".tr(),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '*',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQueryValue(context).heigh * 0.01),
                              DefaultTextForm(
                                aoutofillHints: [AutofillHints.password],
                                controller: confirmPasswordController,
                                isPassword: true,
                                type: TextInputType.visiblePassword,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                hint: 'Enter Password'.tr(),
                                hintStyle:
                                    TextStyle(color: ColorManger.darkColor),
                                prefix: Image(
                                    image: AssetImage(ImageAssets.password)),
                              ),

                              SizedBox(
                                  height:
                                      MediaQueryValue(context).heigh * 0.05),

                              DefaultButton(
                                title: "confirm".tr(),
                                isLoading: state is ChangePasswordLoading,
                                submit: () {
                                  log('dfghjkl;${passwordController.text}  ${confirmPasswordController.text}  ${widget.phone}  ${widget.otp}');
                                  if (loginKey.currentState!.validate()) {
                                    cubit.changePassword(
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                        phone: widget.phone,
                                        code: widget.otp);
                                  }
                                },
                                color: ColorManger.defaultColor,
                                width: MediaQueryValue(context).width * 0.9,
                              ),

                              SizedBox(
                                  height: MediaQueryValue(context).heigh * 0.5),
                            ],
                          ),
                        ),
                      ]),
                ),
              )));
        },
      ),
    );
  }
}
