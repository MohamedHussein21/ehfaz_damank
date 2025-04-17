import 'dart:developer';

import 'package:ahfaz_damanak/core/helper/firebase_helper.dart';
import 'package:ahfaz_damanak/core/storage/hive_helper.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:ahfaz_damanak/features/splach/splach_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/themes/app_theme.dart';
import 'core/helper/bloc_observer.dart';
import 'core/helper/cash_helper.dart';
import 'core/storage/models/auth_box.dart';
import 'features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'features/login/presentation/pages/login_screen.dart';
import 'features/main/presentation/cubit/cubit.dart';
import 'features/main/presentation/pages/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseHelper.init();
  // Initialize both CashHelper (for backward compatibility) and HiveHelper
  await CashHelper.init();
  await HiveHelper.init();

  Widget widget;

  // Try to get data from HiveHelper first, fall back to CashHelper if needed
  bool? onBoarding = HiveHelper.getData(key: 'OnBoarding') ??
      CashHelper.getData(key: 'OnBoarding');
  String? token = HiveHelper.getData(key: 'api_token');
  log('Token from storage: $token');
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
    startLocale: Locale(HiveHelper.getSetting(key: HiveKeys.locale) ??
        CashHelper.getData(key: 'locale') ??
        'ar'),
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
        BlocProvider(create: (context) => BillsScreenCubit()..getFilter()),
        BlocProvider(create: (context) => ProfileScreenCubit()..getProfile()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => AddFatouraCubit()),
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
// 535555651
