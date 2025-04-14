import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/plans/presentation/widgets/payment_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/icons_assets.dart';

class AddBankCardScreen extends StatelessWidget {
  const AddBankCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    final cardNumberController = TextEditingController();

    final dateController = TextEditingController();

    final cvvController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title:
            Text("add bank card".tr(), style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Constants.buildTextField(
                "name on card".tr(), nameController, "enter name on card".tr()),
            SizedBox(height: 12),
            Constants.buildTextField("card number".tr(), cardNumberController,
                "enter card number".tr()),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Constants.buildTextField(
                      'CVV', cvvController, "enter cvv".tr()),
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Constants.buildTextField("enter expiration date",
                        dateController, "month / year".tr())),
              ],
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.defaultColor,
                  side: BorderSide(color: ColorManger.defaultColor),
                  foregroundColor: ColorManger.wightColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Constants.defaultDialog(
                      context: context,
                      title: "add card successfully".tr(),
                      image: IconsAssets.done,
                      action: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManger.defaultColor,
                            side: BorderSide(color: ColorManger.defaultColor),
                            foregroundColor: ColorManger.wightColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {
                            Constants.navigateAndFinish(
                                context, PaymentScreen());
                          },
                          child: Text("back to saved cards".tr()),
                        ),
                      ]);
                },
                child: Text("add".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.purple, size: 50),
              SizedBox(height: 16),
              Text("add card successfully".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  "you can now use your cards to make payments easily and safely"
                      .tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("back to saved cards".tr(),
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
