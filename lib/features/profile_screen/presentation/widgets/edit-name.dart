import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_mange.dart';
import '../../data/models/profile_model.dart';
import 'edit-phone.dart';

class EditNameScreen extends StatefulWidget {
  final Profile profile;
  const EditNameScreen({super.key, required this.profile});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  final TextEditingController nameController = TextEditingController();

  String selectedCountryCode = "+20";
  TextEditingController phoneController = TextEditingController();
  void _selectCountryCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryCodeScreen(onSelect: (code) {
                setState(() {
                  selectedCountryCode = code;
                });
              })),
    );
  }

  @override
  void initState() {
    nameController.text = widget.profile.name;
    phoneController.text = widget.profile.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileScreenCubit(),
      child: BlocConsumer<ProfileScreenCubit, ProfileScreenState>(
        listener: (context, state) {
          if (state is EditProfileLoaded) {
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("account settings".tr()),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  )),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Constants.buildTextField(
                      "name".tr(), nameController, 'mohamed'),
                  SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                  Row(
                    children: [
                      Expanded(
                        child: Constants.buildTextField("Phone Number".tr(),
                            phoneController, "Phone Number".tr()),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: _selectCountryCode,
                        child: SizedBox(
                          width: 70,
                          height: 50,
                          child: Card(
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Text(selectedCountryCode,
                                    style: TextStyle(fontSize: 18)),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                  SizedBox(
                    width: MediaQueryValue(context).width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.defaultColor,
                        side: BorderSide(color: ColorManger.defaultColor),
                        foregroundColor: ColorManger.wightColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        context.read<ProfileScreenCubit>().editProfile(
                              name: nameController.text,
                              phone: phoneController.text,
                            );
                      },
                      child: Text("upgrade".tr()),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
