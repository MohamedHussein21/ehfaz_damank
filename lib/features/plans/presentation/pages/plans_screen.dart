import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../widgets/buy_plan.dart';

class UpgradeAccountScreen extends StatefulWidget {
  const UpgradeAccountScreen({super.key});

  @override
  _UpgradeAccountScreenState createState() => _UpgradeAccountScreenState();
}

class _UpgradeAccountScreenState extends State<UpgradeAccountScreen> {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            _buildPlanSelector(),
            SizedBox(
              height: MediaQueryValue(context).heigh * 0.37,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlanDetails(
                        context: context,
                        planName: 'الباقة المجانية',
                        planPrice: 'free',
                        buttonColor: Colors.green,
                        featureStatus: [true, true, false, false],
                        plantype: 'الباقة الاساسية'),
                    _buildPlanDetails(
                        context: context,
                        planName: 'الباقة المدفوعة',
                        planPrice: '300 ريال ',
                        buttonColor: ColorManger.defaultColor,
                        featureStatus: [true, true, true, true],
                        plantype: 'شراء الباقة'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPlanOption('شهري', 0),
        SizedBox(width: 16),
        _buildPlanOption('سنوي', 1),
      ],
    );
  }

  Widget _buildPlanOption(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedPlan = index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: selectedPlan == index
              ? ColorManger.defaultColor
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(title,
            style: TextStyle(
                fontSize: 16,
                color: selectedPlan == index ? Colors.white : Colors.black)),
      ),
    );
  }

  Widget _buildPlanDetails(
      {required BuildContext context,
      required String planName,
      required String planPrice,
      required Color buttonColor,
      required List<bool> featureStatus,
      required String plantype}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.3,
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
                Text(planName,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                Text(planPrice)
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _buildPlanFeature('تخزين حتى 10 فاتورة', featureStatus[0]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _buildPlanFeature('إشعارات انتهاء الضمان ', featureStatus[1]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _buildPlanFeature('تصدير الفواتير PDF', featureStatus[2]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            _buildPlanFeature('دعم الأولوية', featureStatus[3]),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  side: BorderSide(color: buttonColor),
                  foregroundColor: ColorManger.wightColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Constants.navigateTo(context, BuyPlanScreen());
                },
                child: Text(plantype),
              ),
            ),
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

  Widget _buildCardSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('حدد البطاقة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        RadioListTile(
          title: Text('xxxx xxxx xxxx 8940 - VISA'),
          value: 0,
          groupValue: selectedCard,
          onChanged: (value) => setState(() => selectedCard = value as int),
        ),
        RadioListTile(
          title: Text('xxxx xxxx xxxx 8940 - MasterCard'),
          value: 1,
          groupValue: selectedCard,
          onChanged: (value) => setState(() => selectedCard = value as int),
        ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () => _showSuccessScreen(),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManger.defaultColor,
          minimumSize: Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text('إتمام الدفع',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  void _showSuccessScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          children: [
            Icon(Icons.check_circle, color: ColorManger.defaultColor, size: 60),
            SizedBox(height: 16),
            Text('تم الدفع بنجاح!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('العودة للصفحة الرئيسية'),
            ),
          ),
        ],
      ),
    );
  }
}
