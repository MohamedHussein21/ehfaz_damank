import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../about_us/about_us.dart';
import '../../../bills_screen/presentation/cubit/bills_screen_cubit.dart';
import '../../../contactUs/presentation/pages/contact_screen.dart';
import '../../../notes/presentation/pages/notes.dart';
import '../../../payment/presentation/pages/payment_screen.dart';
import '../../../plans/presentation/pages/plans_screen.dart';
import '../../../profile_screen/presentation/pages/profile-screen.dart';

class BuiltDrawe extends StatefulWidget {
  const BuiltDrawe({super.key});

  @override
  State<BuiltDrawe> createState() => _BuiltDraweState();
}

class _BuiltDraweState extends State<BuiltDrawe> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQueryValue(context).width * 0.75,
      backgroundColor: ColorManger.wightColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserHeader(context),
            ..._buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProfileScreenLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileScreenLoaded) {
          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorManger.defaultColor,
            ),
            accountName:
                Text(state.profile.name, style: TextStyle(fontSize: 20)),
            accountEmail: Text(state.profile.phone),
          );
        }
        return SizedBox();
      },
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      _buildListTile(IconsAssets.profile, "إعدادات الحساب", () {
        Constants.navigateTo(context, ProfileScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.note, "التذكيرات", () {
        Constants.navigateTo(context, RemindersScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.star, "ترقية الحساب", () {
        Constants.navigateTo(context, UpgradeAccountScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.card, "طرق الدفع المحفوظة", () {
        Constants.navigateTo(context, PaymentMethodsScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.invoice, "عن حفظ فواتيرك", () {
        Constants.navigateTo(context, AboutDamanakScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.call, "تواصل معنا", () {
        Constants.navigateTo(context, ContactUsScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.transfer, "نقل الحساب  ", () {
        Constants.showToast(text: "قريبا", state: ToastStates.success);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.move, "نقل الفاتورة  ", () {
        Constants.showToast(text: "قريبا", state: ToastStates.success);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.elements, "تسجيل الخروج", () async {
        await CashHelper.clearData();

        context.read<BillsScreenCubit>().clear();
        context.read<ProfileScreenCubit>().clear();

        Constants.navigateAndFinish(context, const LoginScreen());
      }, color: Colors.red),
    ];
  }

  Widget _buildListTile(String icon, String title, VoidCallback onTap,
      {Color color = Colors.black}) {
    return ListTile(
      leading: Image(
          image: AssetImage(
            icon,
          ),
          width: 30,
          height: 30),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.1);
  }
}
