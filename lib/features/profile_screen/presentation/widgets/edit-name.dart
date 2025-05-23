import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/profile_screen/presentation/cubit/profile_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
                  IntlPhoneField(
                    controller: phoneController,
                    initialCountryCode: 'SA',
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number'.tr(),
                      hintStyle: TextStyle(color: ColorManger.grayColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (phone) {},
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
