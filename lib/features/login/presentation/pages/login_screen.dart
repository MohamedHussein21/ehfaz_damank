import 'dart:developer';
import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/cubit/login_cubit.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/forget_pass.dart';
import 'package:ahfaz_damanak/features/register/presentation/pages/register_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/helper/cash_helper.dart';
import '../../../../core/storage/hive_helper.dart';
import '../../../../core/storage/models/auth_box.dart';
import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/validator.dart';
import '../../../main/presentation/pages/main_screen.dart';
import '../widgets/defaultFormField.dart';
import '../widgets/forget_pass_email.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Validations {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  bool rememberMe = false;
  String? fullPhoneNumber;

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  void _loadRememberedCredentials() async {
    final remember = HiveHelper.getSetting(key: 'remember_me') ?? false;
    if (remember) {
      phoneController.text = HiveHelper.getSetting(key: 'saved_phone') ?? '';
      passwordController.text =
          HiveHelper.getSetting(key: 'saved_password') ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _saveCredentials();
            _saveUserDataAndNavigate(context, state);
          } else if (state is LoginError) {
            String errorMessage = state.responseData ?? state.message;

            if (state.errorCode != null) {
              errorMessage += " (${state.errorCode})";
            }

            Constants.showSnackBar(
              context,
              text: errorMessage,
              color: Colors.red,
              scaffoldContext: context,
            );
          } else if (state is LoginClearingData) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Preparing your session...'.tr()),
                duration: Duration(seconds: 1),
                backgroundColor: ColorManger.defaultColor.withOpacity(0.7),
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQueryValue(context).toPadding * 0.6,
                  vertical: MediaQueryValue(context).toPadding * 1.5,
                ),
                child: Form(
                  key: loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language change button in top right corner
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            _showLanguageBottomSheet(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.locale.languageCode == 'ar'
                                    ? "العربية"
                                    : "English",
                                style: TextStyle(
                                  color: ColorManger.defaultColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.language,
                                color: ColorManger.defaultColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Logo and title
                      Center(
                        child: Image(
                          height: MediaQueryValue(context).heigh * 0.2,
                          image: AssetImage(ImageAssets.logo),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Login'.tr(),
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
                        'Login Discription'.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 14,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.02),

                      // Phone number field
                      Row(
                        children: [
                          Text(
                            'Phone Number'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.01),
                      AutofillGroup(
                        child: Column(
                          children: [
                            Offstage(
                              offstage: true,
                              child: TextFormField(
                                controller: phoneController,
                                autofillHints: const [
                                  AutofillHints.telephoneNumber
                                ],
                              ),
                            ),
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
                                    image: AssetImage(ImageAssets.smartPhone),
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              onChanged: (phone) {
                                fullPhoneNumber = phone.completeNumber;
                                log("Phone: ${phone.completeNumber}");
                              },
                              validator: (value) =>
                                  phoneValidation(value?.number),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQueryValue(context).heigh * 0.01),

                      // Password field
                      Row(
                        children: [
                          Text(
                            'Password'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '*',
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.01),
                      DefaultTextForm(
                        aoutofillHints: [AutofillHints.password],
                        controller: passwordController,
                        isPassword: true,
                        type: TextInputType.visiblePassword,
                        validate: (value) => passwordValidation(value),
                        hint: 'Enter Password'.tr(),
                        hintStyle: TextStyle(color: ColorManger.darkColor),
                        prefix: Image(image: AssetImage(ImageAssets.password)),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.01),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                            activeColor: ColorManger.defaultColor,
                          ),
                          Text('Remember Me'.tr()),
                          Spacer(),
                          TextButton(
                            onPressed: () {
                              Constants.navigateTo(context, ForgetPassEmail());
                            },
                            child: Text(
                              'Forgot Password?'.tr(),
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.04),

                      DefaultButton(
                        title: 'Login'.tr(),
                        isLoading: state is LoginLoading,
                        submit: state is LoginClearingData
                            ? null
                            : () async {
                                if (loginKey.currentState!.validate()) {
                                  final firebaseToken = await FirebaseMessaging
                                          .instance
                                          .getToken() ??
                                      '';
                                  cubit.userLogin(
                                    phone:
                                        fullPhoneNumber ?? phoneController.text,
                                    password: passwordController.text,
                                    googleToken: firebaseToken,
                                  );
                                  await _saveCredentials();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Please fill all required fields'
                                              .tr()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        color: state is LoginClearingData
                            ? ColorManger.defaultColor.withOpacity(0.6)
                            : ColorManger.defaultColor,
                        width: MediaQueryValue(context).width * 0.9,
                      ),

                      if (state is LoginClearingData)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              'Preparing your session...'.tr(),
                              style: TextStyle(
                                color: ColorManger.defaultColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: MediaQueryValue(context).heigh * 0.03),

                      // Register button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?".tr()),
                          TextButton(
                            onPressed: () {
                              Constants.navigateTo(context, RegisterScreen());
                            },
                            child: Text('Sign Up'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.locale.languageCode == 'ar' ? "العربية" : "English",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.language),
                ],
              ),
              const Divider(),
              ListTile(
                leading: Image.asset(
                  ImageAssets.sFlag,
                  width: 24,
                  height: 24,
                ),
                title: const Text("العربية"),
                trailing: context.locale.languageCode == 'ar'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  HiveHelper.saveSetting(key: HiveKeys.locale, value: 'ar');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  ImageAssets.aFlag,
                  width: 24,
                  height: 24,
                ),
                title: const Text("English"),
                trailing: context.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  context.setLocale(const Locale('en'));
                  HiveHelper.saveSetting(key: HiveKeys.locale, value: 'en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveUserDataAndNavigate(
      BuildContext context, LoginSuccess state) async {
    try {
      log("Saving user data and navigating...");

      final apiToken = state.user.apiToken;
      final userId = state.user.data.id;

      final hiveSuccess = await HiveHelper.saveAuth(
        apiToken: apiToken,
        userId: userId,
      );

      final cashTokenSaved =
          await CashHelper.saveData(key: 'api_token', value: apiToken);

      final cashUserIdSaved =
          await CashHelper.saveData(key: 'user_id', value: userId);

      if (!hiveSuccess || !cashTokenSaved || !cashUserIdSaved) {
        throw Exception('Failed to save user data');
      }
      TextInput.finishAutofillContext();
      log('Successfully saved user data for user ID: $userId');
      Constants.navigateAndFinish(context, MainScreen());
    } catch (e) {
      log('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error preparing your session: $e'.tr()),
          backgroundColor: Colors.red,
        ),
      );

      await HiveHelper.clearData();
      await CashHelper.clearData();
    }
  }

  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await HiveHelper.saveSetting(
          key: 'saved_phone', value: phoneController.text);
      await HiveHelper.saveSetting(
          key: 'saved_password', value: passwordController.text);
      await HiveHelper.saveSetting(key: 'remember_me', value: true);
    } else {
      await HiveHelper.removeData(key: 'saved_phone');
      await HiveHelper.removeData(key: 'saved_password');
      await HiveHelper.saveSetting(key: 'remember_me', value: false);
    }
  }
}
