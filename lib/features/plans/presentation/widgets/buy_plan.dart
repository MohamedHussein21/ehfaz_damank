import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/contactUs/presentation/pages/contact_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'payment_screen.dart';

class BuyPlanScreen extends StatefulWidget {
  const BuyPlanScreen({super.key});

  @override
  _BuyPlanScreenState createState() => _BuyPlanScreenState();
}

class _BuyPlanScreenState extends State<BuyPlanScreen> {
  int selectedPlan = 0;
  int selectedCard = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("upgrade account".tr(), style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("choose a plan that meets your needs".tr(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "you can enjoy additional features like unlimited invoice storage, customized notifications, and advanced reports upon subscribing to one of our premium plans."
                            .tr(),
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ]),
            ),
            _buildPlanDetails(),
            SizedBox(
              width: MediaQueryValue(context).width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.defaultColor,
                  side: BorderSide(color: ColorManger.defaultColor),
                  foregroundColor: ColorManger.wightColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Constants.navigateTo(context, ContactUsScreen());
                },
                child: Text("contact us".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.35,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("basic plan".tr(),
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                Text("300 SAR per month".tr())
              ],
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.01),
            _buildPlanFeature("store up to 100 invoices".tr(), true),
            SizedBox(height: MediaQueryValue(context).heigh * 0.01),
            _buildPlanFeature("notifications expiration".tr(), true),
            SizedBox(height: MediaQueryValue(context).heigh * 0.01),
            _buildPlanFeature("export pdf".tr(), true),
            SizedBox(height: MediaQueryValue(context).heigh * 0.01),
            _buildPlanFeature("priority support".tr(), true),
            SizedBox(height: MediaQueryValue(context).heigh * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanFeature(String text, bool available) {
    return Row(
      children: [
        Text(text),
        Spacer(),
        Icon(available ? Icons.check : Icons.close,
            color: available ? Colors.green : Colors.red),
      ],
    );
  }
}
