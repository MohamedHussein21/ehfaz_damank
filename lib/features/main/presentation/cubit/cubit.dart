import 'dart:developer';

import 'package:ahfaz_damanak/features/bills_screen/presentation/pages/bills_screen.dart';
import 'package:ahfaz_damanak/features/main/presentation/cubit/main_state.dart';
import 'package:ahfaz_damanak/features/statistics_screen/presentation/pages/statistics_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../add_fatoura/presentation/pages/add_screen.dart';
import '../../../bills_screen/presentation/cubit/bills_screen_cubit.dart';
import '../../../home_screen/presentation/pages/home_screen.dart';
import '../../../notification/presentation/pages/notification_screen.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(MainInitialStates());

  static MainCubit get(context) => BlocProvider.of(context);

  int pageIndex = 0;
  final pages = [
    HomeScreen(),
    BlocProvider(
      create: (context) => BillsScreenCubit()..getBills(),
      child: const BillsScreen(),
    ),
    const AddNewBill(),
    const StatisticsScreen(),
    const NotificationScreen()
  ];

  changeBottom(int index) {
    log('$index');
    pageIndex = index;
    emit(MainChangButtonNavStates());
  }
}
