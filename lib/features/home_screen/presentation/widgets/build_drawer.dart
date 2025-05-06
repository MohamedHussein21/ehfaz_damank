import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/storage/hive_helper.dart';
import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/icons_assets.dart';
import '../../../../core/utils/mediaQuery.dart';
import '../../../about_us/about_us.dart';
import '../../../contactUs/presentation/pages/contact_screen.dart';
import '../../../login/presentation/cubit/login_cubit.dart';
import '../../../login/presentation/pages/login_screen.dart';
import '../../../plans/presentation/pages/plans_screen.dart';
import '../../../profile_screen/presentation/cubit/profile_screen_cubit.dart';

class BuildDrawer extends StatefulWidget {
  const BuildDrawer({super.key});

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
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

        // Fallback: try to get user data from HiveHelper
        final userId = HiveHelper.getUserId();
        final authData = HiveHelper.getAuth();
        if (userId != null || authData != null) {
          // Trigger profile fetch if we have a user ID but no profile data
          Future.microtask(
              () => context.read<ProfileScreenCubit>().getProfile());

          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorManger.defaultColor,
            ),
            accountName:
                Text("Loading profile...".tr(), style: TextStyle(fontSize: 20)),
            accountEmail: Text("User ID: $userId"),
          );
        }

        return SizedBox(height: 150);
      },
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      _buildListTile(IconsAssets.star, "upgrade account".tr(), () {
        Constants.navigateTo(context, UpgradeAccountScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.transfer, "transfer account".tr(), () {
        Constants.showToast(text: "soon".tr(), state: ToastStates.success);
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.move, "transfer bill".tr(), () {
        Constants.showToast(text: "soon".tr(), state: ToastStates.success);
      }),
      // _buildDivider(),
      // _buildListTile(IconsAssets.card, "saved paid methods".tr(), () {
      //   Constants.navigateTo(context, PaymentMethodsScreen());
      // }),
      _buildDivider(),
      _buildListTile(IconsAssets.invoice, "about saving your bills".tr(), () {
        Constants.navigateTo(context, AboutDamanakScreen());
      }),
      _buildDivider(),
      _buildListTile(IconsAssets.call, "contact us".tr(), () {
        Constants.navigateTo(context, ContactUsScreen());
      }),

      _buildDivider(),
      _buildLogoutTile(context),
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

  Widget _buildLogoutTile(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoggedOut && state.success) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        } else if (state is LoggedOut && !state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? "Failed to sign out properly"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginClearingData;

        return ListTile(
          leading: Image.asset(
            IconsAssets.elements,
            color: isLoading ? ColorManger.grayColor : Colors.red,
            width: 30,
            height: 30,
          ),
          title: isLoading
              ? Row(
                  children: [
                    Text("signing out".tr(),
                        style: TextStyle(
                            color: ColorManger.grayColor, fontSize: 15)),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorManger.grayColor,
                      ),
                    ),
                  ],
                )
              : Text("sigin out".tr(),
                  style: TextStyle(color: Colors.red, fontSize: 15)),
          onTap: isLoading
              ? null
              : () => _showLogoutConfirmation(
                    context,
                    onTap: () async {
                      final loginCubit = context.read<LoginCubit>();
                      await loginCubit.logout(context);
                      Navigator.pop(context);
                    },
                  ),
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context,
      {required Function() onTap}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("sign out".tr()),
        content: Text("are you sure you want to sign out?".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("cancel".tr(), style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => onTap(),
            child: Text("sign out".tr(), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 0.1);
  }
}
