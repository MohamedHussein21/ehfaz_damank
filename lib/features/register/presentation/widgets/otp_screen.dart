
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:ahfaz_damanak/features/register/presentation/cubit/register_screen_cubit.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/images_mange.dart';
import '../../../login/presentation/pages/login_screen.dart';
import '../../../login/presentation/widgets/defauldButton.dart';
import '../../data/models/register_model.dart';

class OtpScreen extends StatefulWidget {
  final RegisterModel model;
  const OtpScreen({super.key, required this.model});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<TextEditingController> otpControllers;
  String verificationCode = '';

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (index) => TextEditingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String otpString = widget.model.verified.toString().padLeft(4, '0');
      for (int i = 0; i < otpControllers.length; i++) {
        otpControllers[i].text = otpString[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterScreenVerifyError) {
            Constants.showSnackBar(context,
                text: state.message,
                color: Colors.red,
                scaffoldContext: context);
          }
          if (state is RegisterScreenVerifySuccess) {
            Constants.showSnackBar(context,
                text: 'Verify Success'.tr(),
                color: Colors.green,
                scaffoldContext: context);
            Constants.navigateAndFinish(context, MainScreen());
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
                    fieldWidth: MediaQuery.of(context).size.width * 0.14,
                    borderRadius: BorderRadius.circular(10),
                    numberOfFields: 4,
                    borderColor: Color(0xFF512DA8),
                    showFieldAsBox: true,
                    handleControllers: (controllers) {
                      for (int i = 0; i < controllers.length; i++) {
                        controllers[i] = otpControllers[i];
                      }
                    },
                    onCodeChanged: (String code) {},
                    onSubmit: (String code) {
                      setState(() {
                        verificationCode = code;
                      });
                      print("Entered OTP: $verificationCode");
                    },
                  ),
                  SizedBox(height: MediaQueryValue(context).heigh * 0.1),
                  BuildCondition(
                    condition: state is RegisterScreenVerifyLoading,
                    builder: (context) => CircularProgressIndicator(),
                    fallback: (context) => DefaultButton(
                      title: 'Confirm'.tr(),
                      submit: () {
                        cubit.userVerify(
                            phone: widget.model.data.phone,
                            otp: widget.model.verified);
                      },
                      width: MediaQueryValue(context).width * 0.9,
                    ),
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
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
