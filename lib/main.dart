import 'dart:developer';

import 'package:ahfaz_damanak/features/splach/splach_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/themes/app_theme.dart';
import 'core/helper/bloc_observer.dart';
import 'core/helper/cash_helper.dart';
import 'features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'features/login/presentation/pages/login_screen.dart';
import 'features/main/presentation/cubit/cubit.dart';
import 'features/main/presentation/pages/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await CashHelper.init();

  Widget widget;

  bool? onBoarding = CashHelper.getData(key: 'OnBoarding');
  String? token = CashHelper.getData(key: 'api_token');
  log(token.toString());
  if (onBoarding != null) {
    if (token != null) {
      widget = const MainScreen();
    } else {
      widget = const LoginScreen();
    }
  } else {
    widget = const SplashScreen();
  }

  Bloc.observer = MyBlocObserver();

  runApp(EasyLocalization(
    path: 'assets/lang',
    supportedLocales: const [
      Locale('en'),
      Locale('ar'),
    ],
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    child: MyApp(startWidget: widget),
  ));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(),
        ),
        BlocProvider(create: (context) => BillsScreenCubit()..getBills()),
      ],
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Ehfaz Damanak',
        theme: appTheme(),
        home: startWidget,
      ),
    );
  }
}
