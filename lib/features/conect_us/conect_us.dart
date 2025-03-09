import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:flutter/material.dart';

import '../../core/utils/icons_assets.dart';
import '../main/presentation/pages/main_screen.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final mailController = TextEditingController();

    final massageontroller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('تواصل معنا', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildContactOption(Icons.phone, 'تواصل معنا',
                    'متاحًا على الخط من الاثنين إلى الجمعة 17-9'),
                SizedBox(width: 10),
                _buildContactOption(Icons.mail_outline, 'البريد الإلكتروني',
                    'متاحًا على الخط من الاثنين إلى الجمعة 17-9'),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'اكتب تفاصيل استفسارك أو الشكوى، وسنقوم بالرد عليك في أقرب وقت ممكن.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Constants.buildTextField(
                'رقم الجوال', phoneController, 'ادخل رقم الجوال'),
            SizedBox(height: 10),
            Constants.buildTextField(
                'البريد الخاص بك', phoneController, 'ادخل البريد الخاص بك'),
            SizedBox(height: 10),
            Constants.buildTextField(
                'تفاصيل الشكوى', phoneController, 'ادخل تفاصيل الشكوى',
                maxLine: 4),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.defaultColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Constants.defaultDialog(
                      context: context,
                      title: 'تم  ارسال الشكوي ',
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
                          child: const Text("العودة الي  الصفحة الرئيسية"),
                        ),
                      ]);
                },
                child: Text('إرسال',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
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
