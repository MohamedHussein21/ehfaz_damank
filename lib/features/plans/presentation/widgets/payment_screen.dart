import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedCard = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("choose a payment method".tr(),
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardOption(
                0, 'xxxx xxxx xxxx 8940', 'VISA', ColorManger.defaultColor),
            _buildCardOption(
                1, 'xxxx xxxx xxxx 8940', 'MasterCard', Colors.orange),
            SizedBox(height: 16),
            Center(
              child: Text(
                "add new card".tr(),
                style: TextStyle(color: Colors.lightBlue, fontSize: 16),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Constants.defaultDialog(
                    context: context,
                    title: "payment successfully".tr(),
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
                          Constants.navigateAndFinish(context, MainScreen());
                        },
                        child: Text("back to home".tr(),
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManger.defaultColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("buy".tr(),
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOption(
      int index, String cardNumber, String brand, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedCard == index
              ? ColorManger.defaultColor
              : Colors.grey.shade300,
          width: selectedCard == index ? 2 : 1,
        ),
      ),
      child: RadioListTile(
        value: index,
        groupValue: selectedCard,
        onChanged: (value) => setState(() => selectedCard = value as int),
        title: Text(cardNumber, style: TextStyle(fontSize: 16)),
        subtitle: Text('7/10', style: TextStyle(color: Colors.grey)),
        secondary: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
          child:
              Text(brand, style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}
