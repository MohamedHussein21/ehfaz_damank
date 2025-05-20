import 'dart:math';

import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/login/presentation/cubit/login_cubit.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defaultFormField.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/otp_screen.dart';
import 'package:ahfaz_damanak/features/register/presentation/widgets/otp_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/images_mange.dart';
import '../../../../core/utils/validator.dart';

class ForgetPassEmail extends StatefulWidget {
  const ForgetPassEmail({super.key});

  @override
  State<ForgetPassEmail> createState() => _ForgetPassEmailState();
}

class _ForgetPassEmailState extends State<ForgetPassEmail> with Validations {
  final loginKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  String? fullPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is SendVerifyForgetPasswordEmailSuccess) {
            Constants.navigateTo(
                context, OtpScreenScreen(phone: fullPhoneNumber ?? ''));
          }
          if (state is SendVerifyForgetPasswordEmailError) {
            Constants.showSnackBar(context,
                text: state.message,
                color: Colors.red,
                scaffoldContext: context);
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
                        Center(
                          child: Image(
                            height: MediaQueryValue(context).heigh * 0.2,
                            image: AssetImage(ImageAssets.logo),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Enter Phone Number".tr(),
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

                        SizedBox(height: MediaQueryValue(context).heigh * 0.02),

                        // Phone number field

                        AutofillGroup(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Phone Number".tr(),
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
                              SizedBox(height: 5),

                              IntlPhoneField(
                                controller: phoneController,
                                initialCountryCode: 'SA',
                                decoration: InputDecoration(
                                  hintText: 'Enter Phone Number'.tr(),
                                  hintStyle:
                                      TextStyle(color: ColorManger.grayColor),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image(
                                        image:
                                            AssetImage(ImageAssets.smartPhone),
                                        height: 24,
                                        width: 24),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (phone) {
                                  fullPhoneNumber = phone.completeNumber;
                                  print(phone.completeNumber);
                                },
                                validator: (value) =>
                                    phoneValidation(value?.number),
                              ),
                              SizedBox(
                                  height:
                                      MediaQueryValue(context).heigh * 0.01),

                              // Password field

                              SizedBox(
                                  height:
                                      MediaQueryValue(context).heigh * 0.05),

                              DefaultButton(
                                title: "sent".tr(),
                                isLoading: state
                                    is SendVerifyForgetPasswordEmailLoading,
                                submit: () {
                                  if (loginKey.currentState!.validate()) {
                                    cubit.sentVerifyForgetPassword(
                                      phone: fullPhoneNumber ??
                                          phoneController.text,
                                    );
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
