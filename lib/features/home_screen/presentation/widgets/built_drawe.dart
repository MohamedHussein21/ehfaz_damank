import 'package:ahfaz_damanak/core/helper/cash_helper.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';
import 'package:ahfaz_damanak/features/main/presentation/cubit/cubit.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../main.dart';
import '../../../about_us/about_us.dart';
import '../../../bills_screen/presentation/cubit/bills_screen_cubit.dart';
import '../../../contactUs/presentation/pages/contact_screen.dart';
import '../../../login/presentation/cubit/login_cubit.dart';
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
      _buildListTile(IconsAssets.profile, "account settings".tr(), () {
        Constants.navigateTo(context, ProfileScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.note, "reminders".tr(), () {
        Constants.navigateTo(context, RemindersScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.star, "upgrade account".tr(), () {
        Constants.navigateTo(context, UpgradeAccountScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.card, "saved paid methods".tr(), () {
        Constants.navigateTo(context, PaymentMethodsScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.invoice, "about saving your bills".tr(), () {
        Constants.navigateTo(context, AboutDamanakScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.call, "contact us".tr(), () {
        Constants.navigateTo(context, ContactUsScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.transfer, "transfer account".tr(), () {
        Constants.showToast(text: "soon".tr(), state: ToastStates.success);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.move, "transfer bill".tr(), () {
        Constants.showToast(text: "soon".tr(), state: ToastStates.success);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.language, "change language".tr(), () {
        final isArabic = context.locale.languageCode == 'ar';
        final newLocale = isArabic ? const Locale('en') : const Locale('ar');

        context.setLocale(newLocale);
        CashHelper.saveData(key: 'locale', value: newLocale.languageCode);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.elements, "sigin out".tr(), () async {
        await CashHelper.clearData();
        await CashHelper.removeData(key: 'api_token');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => LoginCubit()),
              ],
              child: const LoginScreen(),
            ),
          ),
        );
      }, color: Colors.red)
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
      title: Text(title, style: TextStyle(color: color, fontSize: 15)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.1);
  }
}

void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                context.setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
