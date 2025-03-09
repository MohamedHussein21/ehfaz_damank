import 'package:flutter/material.dart';

import '../widgets/edit_name.dart';
import '../widgets/edit_passord.dart';
import '../widgets/editi_phone.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Mohamed Huusein";
  String phoneNumber = "010xxxxxxxx";
  String password = "**********";
  String countryCode = "+20";

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    ).then((value) {
      if (value != null) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعدادات الحساب")),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text("المعلومات الشخصية ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildProfileTile(
              "الاسم", name, () => _navigateToScreen(EditNameScreen())),
          _buildProfileTile("رقم الجوال", "$countryCode $phoneNumber",
              () => _navigateToScreen(EditPhoneNumberScreen())),
          Text("الأمان والخصوصية",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _buildProfileTile("كلمة المرور", password,
              () => _navigateToScreen(EditPasswordScreen())),
        ],
      ),
    );
  }

  Widget _buildProfileTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(Icons.edit),
      onTap: onTap,
    );
  }
}
