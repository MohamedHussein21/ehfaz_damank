import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
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
    return BlocProvider(
      create: (context) => ProfileScreenCubit()..getProfile(),
      child: BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileScreenLoading) {
            return Scaffold(
              appBar: AppBar(title: Text("إعدادات الحساب")),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is ProfileScreenLoaded) {
            final profile = state.profile;

            return Scaffold(
              appBar: AppBar(
                title: Text("إعدادات الحساب"),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
                ),
              ),
              body: ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Text("المعلومات الشخصية",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildProfileTile("الاسم", profile.name,
                      () => _navigateToScreen(EditNameScreen(profile: profile))),
                  _buildProfileTile("رقم الجوال", profile.phone,
                      () => _navigateToScreen(EditNameScreen(profile: profile))),
                  Text("الأمان والخصوصية",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  _buildProfileTile("كلمة المرور", "**********",
                      () => _navigateToScreen(EditPasswordScreen())),

                  SizedBox(height: 20),

                  _buildDeleteAccountButton(),
                ],
              ),
            );
          } else if (state is ProfileScreenError) {
            return Scaffold(
              appBar: AppBar(title: Text("إعدادات الحساب")),
              body: Center(child: Text("حدث خطأ أثناء تحميل البيانات!")),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text("إعدادات الحساب")),
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildProfileTile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: Icon(Icons.edit),
      onTap: onTap,
    );
  }

  Widget _buildDeleteAccountButton() {
    return Row(
      children: [
        Image(image: AssetImage(IconsAssets.profileRemove),),
        TextButton(
          onPressed: () => _showDeleteAccountDialog(),
          child: Text(
            "حذف الحساب",
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
        title: Text("حذف الحساب"),
        content: Text("هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء."),
        actions: [
          TextButton(
            onPressed: () {
              var Cubit = BlocProvider.of<ProfileScreenCubit>(context);
              Cubit.deleteUser(userId: Cubit.profile?.id.toString() ?? '');
              Navigator.pop(context);
              
            },
            child: Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
               var Cubit = BlocProvider.of<ProfileScreenCubit>(context);
              Cubit.deleteUser(userId: Cubit.profile?.id.toString() ?? '');
              Constants.navigateAndFinish(context, LoginScreen());
              
            },
            child: Text("حذف", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


}
