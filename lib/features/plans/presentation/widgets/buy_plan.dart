import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
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
        title: Text('ترقية الحساب', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('اختر الباقة المناسبة لاحتياجاتك',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                          'تمتع بمزايا إضافية مثل تخزين غير محدود للفواتير، إشعارات مخصصة، وتقارير متقدمة عند الاشتراك في إحدى باقاتنا المميزة.',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    Constants.navigateTo(context, PaymentScreen());
                  },
                  child: Text("  اتمام الشراء   "),
                ),
              ),
            ],
          ),
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
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('الباقة الأساسية',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text('300 ريال /شهر ')
                ],
              ),
              SizedBox(height: MediaQueryValue(context).heigh * 0.01),
              _buildPlanFeature('تخزين حتى 100 فاتورة', true),
              SizedBox(height: MediaQueryValue(context).heigh * 0.01),
              _buildPlanFeature('إشعارات انتهاء الضمان ', true),
              SizedBox(height: MediaQueryValue(context).heigh * 0.01),
              _buildPlanFeature('تصدير الفواتير PDF', true),
              SizedBox(height: MediaQueryValue(context).heigh * 0.01),
              _buildPlanFeature('دعم الأولوية', true),
              SizedBox(height: MediaQueryValue(context).heigh * 0.02),
            ],
          ),
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
