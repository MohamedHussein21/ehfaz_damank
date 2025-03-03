import 'package:ahfaz_damanak/config/themes/app_theme.dart';
import 'package:ahfaz_damanak/features/splach/splach_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'core/helper/cash_helper.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    path: 'assets/lang',
    supportedLocales: const [
      Locale('en'),
      Locale('tr'),
    ],
    fallbackLocale: Locale('tr'),
    child: const MyApp(),
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();

  // Widget widget;

  // bool? onBoarding = CashHelper.getData(key: 'OnBoarding');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Ehfaz Damanak',
      theme: appTheme(),
      home: SplashScreen(),
    );
  }
}
