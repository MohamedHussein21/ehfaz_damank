import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الاشعارات',
          style: TextStyle(color: ColorManger.blackColor),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: mediaQuery.height * 0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Flexible(
                child: Text(
                  'تم رفع الفاتورة بنجاح! لا تنسَ إضافة التذكيرات لضمان متابعة الضمان بسهولة. $index',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: index < 2
                      ? Image.asset(IconsAssets.notificationDone)
                      : Image.asset(IconsAssets.notificationNotDone),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
