import 'dart:math';

import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/register/presentation/cubit/register_screen_cubit.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/validator.dart';
import '../../../login/presentation/pages/login_screen.dart';
import '../../../login/presentation/widgets/defauldButton.dart';
import '../../../login/presentation/widgets/defaultFormField.dart';
import '../widgets/otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Validations {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          log(state.hashCode);

          if (state is RegisterScreenSuccess) {
            CashHelper.saveData(key: 'api_token', value: state.user.apiToken)
                .then((value) {
              CashHelper.saveData(key: 'user_id', value: state.user.data.id);
              Constants.navigateTo(
                  context,
                  OtpScreen(
                    model: state.user,
                  ));
            });
          } else if (state is RegisterScreenError) {
            Constants.showSnackBar(context,
                text: state.message,
                color: Colors.red,
                scaffoldContext: context);
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryValue(context).toPadding * 0.9,
                  vertical: MediaQueryValue(context).toPadding * 3,
                ),
                child: Form(
                  key: formKey,
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
                          'Confirm Number Phone'.tr(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text('Login Discription'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      Text(
                        'Name'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      DefaultTextForm(
                        controller: nameController,
                        isPassword: false,
                        type: TextInputType.text,
                        validate: (value) => generalValidation(value),
                        hint: 'Enter Your name'.tr(),
                        hintStyle: TextStyle(color: ColorManger.grayColor),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      Text(
                        'Phone Number'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      IntlPhoneField(
                        controller: phoneController,
                        initialCountryCode: 'SA',
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number'.tr(),
                          hintStyle: TextStyle(color: ColorManger.grayColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image(
                                image: AssetImage(ImageAssets.smartPhone),
                                height: 24,
                                width: 24),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                        validator: (value) => phoneValidation(value?.number),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      Text(
                        'Password'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      DefaultTextForm(
                        controller: passwordController,
                        isPassword: false,
                        type: TextInputType.text,
                        validate: (value) => passwordValidation(value),
                        hint: 'Enter Password'.tr(),
                        hintStyle: TextStyle(color: ColorManger.grayColor),
                        prefix: Image(image: AssetImage(ImageAssets.password)),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      Text(
                        'Confirm Password'.tr(),
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      DefaultTextForm(
                        controller: confirmPasswordController,
                        isPassword: false,
                        type: TextInputType.text,
                        validate: (value) {
                          passwordValidation(value);
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        hint: 'Confirm Password'.tr(),
                        hintStyle: TextStyle(color: ColorManger.grayColor),
                        prefix: Image(image: AssetImage(ImageAssets.password)),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.04),
                      BuildCondition(
                          condition: state is! RegisterScreenLoading,
                          builder: (context) {
                            return DefaultButton(
                              title: 'Login'.tr(),
                              submit: () async {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          confirmPasswordController.text,
                                      googleToken: (await FirebaseMessaging
                                              .instance
                                              .getToken()) ??
                                          '');
                                }
                              },
                              width: MediaQueryValue(context).width * 0.9,
                            );
                          },
                          fallback: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                              onPressed: () {
                                Constants.navigateTo(context, LoginScreen());
                              },
                              child: Text(
                                'Login'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
