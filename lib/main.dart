import 'package:ahfaz_damanak/features/splach/splach_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/themes/app_theme.dart';
import 'core/helper/cash_helper.dart';
import 'features/main/presentation/cubit/cubit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    path: 'assets/lang',
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    fallbackLocale: Locale('ar'),
    startLocale: Locale('ar'),
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(),
        ),
      ],
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Ehfaz Damanak',
        theme: appTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
