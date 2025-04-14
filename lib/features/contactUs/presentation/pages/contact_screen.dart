import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/contactUs/presentation/cubit/contactus_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/icons_assets.dart';
import '../../../main/presentation/pages/main_screen.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final mailController = TextEditingController();

    final massageontroller = TextEditingController();

    return BlocProvider(
      create: (context) => ContactusCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("contact us".tr(), style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildContactOption(Icons.phone, "contact us".tr(),
                        "available from Tuesday to Friday 17-9".tr()),
                    SizedBox(width: 10),
                    _buildContactOption(Icons.mail_outline, "email".tr(),
                        "available from Tuesday to Friday 17-9".tr()),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "write your query or complain, we will respond to you as soon as possible"
                      .tr(),
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Constants.buildTextField("phone number".tr(), phoneController,
                    "enter phone number".tr()),
                SizedBox(height: 10),
                Constants.buildTextField(
                    "your email".tr(), mailController, "enter your email".tr()),
                SizedBox(height: 10),
                Constants.buildTextField("complain details".tr(),
                    massageontroller, "enter your complain".tr(),
                    maxLine: 4),
                SizedBox(height: 20),
                BlocConsumer<ContactusCubit, ContactusState>(
                  listener: (context, state) {
                    if (state is ContactusSuccess) {
                      Constants.defaultDialog(
                          context: context,
                          title: "complain sent".tr(),
                          image: IconsAssets.done,
                          action: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManger.defaultColor,
                                side:
                                    BorderSide(color: ColorManger.defaultColor),
                                foregroundColor: ColorManger.wightColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                              ),
                              onPressed: () {
                                Constants.navigateAndFinish(
                                    context, MainScreen());
                              },
                              child: Text("back to home".tr()),
                            ),
                          ]);
                    }
                  },
                  builder: (context, state) {
                    var cubit = ContactusCubit.get(context);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.defaultColor,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          cubit.sentMassege(
                              email: mailController.text,
                              phone: phoneController.text,
                              content: massageontroller.text);
                        },
                        child: Text("sent".tr(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Icon(icon, color: ColorManger.defaultColor, size: 30),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
