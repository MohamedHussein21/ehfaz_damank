import 'dart:developer';
import 'package:ahfaz_damanak/core/utils/images_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/cubit/login_cubit.dart';
import 'package:ahfaz_damanak/features/login/presentation/widgets/defauldButton.dart';
import 'package:ahfaz_damanak/features/register/presentation/pages/register_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/helper/cash_helper.dart';
import '../../../../core/storage/hive_helper.dart';
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
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Use async/await pattern for sequential operations
            _saveUserDataAndNavigate(context, state);
          } else if (state is LoginError) {
            // Show error message with appropriate context
            String errorMessage = state.message;

            // Add more helpful context if available
            if (state.errorCode != null) {
              errorMessage += " (${state.errorCode})";
            }

            // Show the error message
            Constants.showSnackBar(context,
                text: errorMessage,
                color: Colors.red,
                scaffoldContext: context);
          } else if (state is LoginClearingData) {
            // Show a temporary message that we're preparing the session
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
                      // Logo and title
                      Center(
                        child: Image(
                          height: MediaQueryValue(context).heigh * 0.2,
                          image: AssetImage(ImageAssets.logo),
                          color: ColorManger.defaultColor,
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
                          log("Phone: ${phone.completeNumber}");
                        },
                        validator: (value) => phoneValidation(value?.number),
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
                        controller: passwordController,
                        isPassword: true,
                        type: TextInputType.visiblePassword,
                        validate: (value) => passwordValidation(value),
                        hint: 'Enter Password'.tr(),
                        hintStyle: TextStyle(color: ColorManger.darkColor),
                        prefix: Image(image: AssetImage(ImageAssets.password)),
                      ),
                      SizedBox(height: MediaQueryValue(context).heigh * 0.04),

                      // Login button with loading state
                      DefaultButton(
                        title: 'Login'.tr(),
                        // Only show loading indicator during actual login attempt
                        isLoading: state is LoginLoading,
                        // Disable button during data clearing
                        submit: state is LoginClearingData
                            ? null
                            : () async {
                                if (loginKey.currentState!.validate()) {
                                  // Get firebase token
                                  final firebaseToken = await FirebaseMessaging
                                          .instance
                                          .getToken() ??
                                      '';

                                  // Call login
                                  cubit.userLogin(
                                    phone: phoneController.text,
                                    password: passwordController.text,
                                    googleToken: firebaseToken,
                                  );
                                } else {
                                  // Show validation error message
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
                        // Set color based on state
                        color: state is LoginClearingData
                            ? ColorManger.defaultColor.withOpacity(0.6)
                            : ColorManger.defaultColor,
                        width: MediaQueryValue(context).width * 0.9,
                      ),

                      // Loading message during data clearing
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

  /// Helper method to save user data and navigate to main screen
  /// Uses a sequential approach with proper error handling
  Future<void> _saveUserDataAndNavigate(
      BuildContext context, LoginSuccess state) async {
    try {
      log("Saving user data and navigating...");

      final apiToken = state.user.apiToken;
      final userId = state.user.data.id;

      // Save to both storage systems for compatibility
      // First save to HiveHelper (modern storage)
      final hiveSuccess = await HiveHelper.saveAuth(
        apiToken: apiToken,
        userId: userId,
      );

      // Also save to CashHelper (legacy storage)
      final cashTokenSaved =
          await CashHelper.saveData(key: 'api_token', value: apiToken);

      final cashUserIdSaved =
          await CashHelper.saveData(key: 'user_id', value: userId);

      // Verify all operations succeeded
      if (!hiveSuccess || !cashTokenSaved || !cashUserIdSaved) {
        throw Exception('Failed to save user data');
      }

      // Log successful data saving
      log('Successfully saved user data for user ID: $userId');

      // Navigate to main screen
      Constants.navigateAndFinish(context, MainScreen());
    } catch (e) {
      // Handle errors during data saving
      log('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error preparing your session: $e'.tr()),
          backgroundColor: Colors.red,
        ),
      );

      // Clear any partial data that might have been saved
      await HiveHelper.clearData();
      await CashHelper.clearData();
    }
  }
}
