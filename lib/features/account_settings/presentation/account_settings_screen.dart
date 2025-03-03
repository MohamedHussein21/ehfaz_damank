import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/account_settings/presentation/widgets/personal_information_section.dart';
import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.defaultAppBar(context, txt: 'إعدادات الحساب'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'المعلومات الشخصية',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: 30,
            ),
            PersonalInformationSection(
              title: 'الإسم',
              subtitle: 'ahmed Elamrity',
              onTap: () {},
            ),
            PersonalInformationSection(
              title: 'رقم الجوال',
              subtitle: '01123808953',
              onTap: () {},
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'الأمان والخصوصية',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: 30,
            ),
            PersonalInformationSection(
              title: 'كلمة المرور',
              subtitle: '********',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
