import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';

class EditPhoneNumberScreen extends StatefulWidget {
  const EditPhoneNumberScreen({super.key});

  @override
  _EditPhoneNumberScreenState createState() => _EditPhoneNumberScreenState();
}

class _EditPhoneNumberScreenState extends State<EditPhoneNumberScreen> {
  String selectedCountryCode = "+20";
  TextEditingController phoneController = TextEditingController();

  void _selectCountryCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryCodeScreen(onSelect: (code) {
                setState(() {
                  selectedCountryCode = code;
                });
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات الحساب")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: MediaQueryValue(context).heigh * 0.03),
            Row(
              children: [
                Expanded(
                  child: Constants.buildTextField(
                      'رقم الجوال ', phoneController, 'رقم الجوال '),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: _selectCountryCode,
                  child: SizedBox(
                    width: 70,
                    height: 50,
                    child: Card(
                      color: Colors.grey[200],
                      child: Row(
                        children: [
                          Text(selectedCountryCode,
                              style: TextStyle(fontSize: 18)),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQueryValue(context).heigh * 0.07),
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
                  Navigator.pop(context);
                },
                child: Text("تحديث"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CountryCodeScreen extends StatelessWidget {
  final Function(String) onSelect;
  CountryCodeScreen({required this.onSelect});

  final List<String> countryCodes = ["+20", "+1", "+44", "+971"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اختر كود الدولة")),
      body: ListView.builder(
        itemCount: countryCodes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(countryCodes[index]),
            onTap: () {
              onSelect(countryCodes[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
