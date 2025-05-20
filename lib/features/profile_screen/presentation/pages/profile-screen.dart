import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/features/login/presentation/cubit/login_cubit.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/edit-name.dart';
import '../widgets/edit-password.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileScreenCubit()..getProfile()),
        BlocProvider(create: (context) => LoginCubit()),
      ],
      child: BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Constants.navigateAndFinish(context, LoginScreen());
          } else if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileScreenLoading) {
            return Scaffold(
              appBar: AppBar(
                title: Text("account settings".tr()),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileScreenLoaded) {
            final profile = state.profile;

            return Scaffold(
              appBar: AppBar(
                title: Text("account settings".tr()),
              ),
              body: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text("personal information".tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildProfileTile(
                      "name".tr(),
                      profile.name,
                      () =>
                          _navigateToScreen(EditNameScreen(profile: profile))),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade100,
                  ),
                  _buildProfileTile(
                      "Phone Number".tr(),
                      profile.phone,
                      () =>
                          _navigateToScreen(EditNameScreen(profile: profile))),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade100,
                  ),
                  Text("privacy and security".tr(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildProfileTile("Password".tr(), "**********",
                      () => _navigateToScreen(EditPasswordScreen())),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(height: 10),
                  _buildDeleteAccountButton(),
                ],
              ),
            );
          } else if (state is ProfileScreenError) {
            return Scaffold(
              appBar: AppBar(title: Text("account settings".tr())),
              body: Center(child: Text("something went wrong".tr())),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text("account settings".tr())),
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(value, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.edit),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountButton() {
    return Row(
      children: [
        Image(
          image: AssetImage(IconsAssets.profileRemove),
        ),
        TextButton(
          onPressed: () => _showDeleteAccountDialog(),
          child: Text(
            "delete account".tr(),
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("delete account".tr()),
        content: Text(
            "are you sure you want to delete your account? this action cannot be undone"
                .tr()),
        actions: [
          TextButton(
            onPressed: () {
              var Cubit = BlocProvider.of<ProfileScreenCubit>(context);
              Cubit.deleteUser(userId: Cubit.profile?.id.toString() ?? '');
              Navigator.pop(context);
            },
            child: Text("cancel".tr(), style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              var Cubit = BlocProvider.of<ProfileScreenCubit>(context);
              Cubit.deleteUser(userId: Cubit.profile?.id.toString() ?? '');
              Constants.navigateAndFinish(context, LoginScreen());
            },
            child: Text("delete".tr(), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final cubit = BlocProvider.of<ProfileScreenCubit>(context);

    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        return Row(
          children: [
            Image(
              image: AssetImage(IconsAssets.elements),
              color: ColorManger.grayColor,
            ),
            SizedBox(width: 8),
            TextButton(
              onPressed: state is LogoutLoading
                  ? null
                  : () => _showLogoutDialog(context),
              child: state is LogoutLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "signing out".tr(),
                          style: TextStyle(
                              color: ColorManger.grayColor, fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ],
                    )
                  : Text(
                      "sign out".tr(),
                      style: TextStyle(
                          color: ColorManger.defaultColor, fontSize: 16),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
            child: Text("cancel".tr(),
                style: TextStyle(color: ColorManger.grayColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              var cubit = BlocProvider.of<ProfileScreenCubit>(context);
              cubit.logout(context);
            },
            child: Text("sign out".tr(),
                style: TextStyle(color: ColorManger.defaultColor)),
          ),
        ],
      ),
    );
  }
}
