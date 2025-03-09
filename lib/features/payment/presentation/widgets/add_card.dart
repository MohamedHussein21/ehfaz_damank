import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/plans/presentation/widgets/payment_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/icons_assets.dart';
import '../../../main/presentation/pages/main_screen.dart';

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
        title: Text('إضافة بطاقة بنكية', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.buildTextField(
                'اسم حامل البطاقة', nameController, 'ادخل اسم حامل البطاقة'),
            SizedBox(height: 12),
            Constants.buildTextField(
                'رقم البطاقة', cardNumberController, 'ادخل رقم البطاقة'),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Constants.buildTextField(
                      'CVV', cvvController, 'ادخل CVV'),
                ),
                SizedBox(width: 12),
                Expanded(
                    child: Constants.buildTextField(
                        'تاريخ الانتهاء', cvvController, 'شهر / سنة'))
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
                      title: 'تم اضافة الكارت بنجاح  ',
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
                          child: const Text("العودة الي  البطاقات المحفوظة  "),
                        ),
                      ]);
                },
                child: const Text('اضافة '),
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
              Text('تم إضافة البطاقة بنجاح!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                  'يمكنك الآن استخدام بطاقتك لإتمام عمليات الدفع بسهولة وأمان.',
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
                child: Text('العودة إلى البطاقات المحفوظة',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
