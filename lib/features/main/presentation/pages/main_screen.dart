import 'package:ahfaz_damanak/features/main/presentation/cubit/main_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/icons_assets.dart';
import '../cubit/cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, stata) {},
      builder: (context, stata) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () => cubit.changeBottom(cubit.pageIndex = 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
          body: cubit.pages[cubit.pageIndex],
          bottomNavigationBar: Container(
            height: 80,
            decoration: BoxDecoration(
              color: ColorManger.wightColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit.changeBottom(cubit.pageIndex = 0);
                      },
                      icon: cubit.pageIndex == 0
                          ? Image(
                              image: AssetImage(IconsAssets.home),
                              color: ColorManger.defaultColor,
                            )
                          : Image(
                              image: AssetImage(IconsAssets.home),
                              color: ColorManger.grayColor,
                            ),
                    ),
                    Text(
                      'Main'.tr(),
                      style: TextStyle(
                          color: cubit.pageIndex == 0
                              ? ColorManger.defaultColor
                              : ColorManger.grayColor),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit.changeBottom(cubit.pageIndex = 1);
                      },
                      icon: cubit.pageIndex == 1
                          ? Image(
                              image: AssetImage(IconsAssets.bills),
                              color: ColorManger.defaultColor,
                            )
                          : Image(
                              image: AssetImage(IconsAssets.bills),
                              color: ColorManger.grayColor,
                            ),
                    ),
                    Text(
                      'Bills'.tr(),
                      style: TextStyle(
                          color: cubit.pageIndex == 1
                              ? ColorManger.defaultColor
                              : ColorManger.grayColor),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        cubit.changeBottom(cubit.pageIndex = 3);
                      },
                      icon: cubit.pageIndex == 3
                          ? Image(
                              image: AssetImage(IconsAssets.stat),
                              color: ColorManger.defaultColor,
                            )
                          : Image(
                              image: AssetImage(IconsAssets.stat),
                              color: ColorManger.grayColor,
                            ),
                    ),
                    Text(
                      'Statistics'.tr(),
                      style: TextStyle(
                          color: cubit.pageIndex == 3
                              ? ColorManger.defaultColor
                              : ColorManger.grayColor),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                        onPressed: () {
                          cubit.changeBottom(cubit.pageIndex = 4);
                        },
                        icon: cubit.pageIndex == 4
                            ? Icon(Icons.person_outline_outlined,
                                color: ColorManger.defaultColor)
                            : Icon(Icons.person_outline_outlined,
                                color: ColorManger.grayColor)),
                    Text(
                      "me".tr(),
                      style: TextStyle(
                          color: cubit.pageIndex == 4
                              ? ColorManger.defaultColor
                              : ColorManger.grayColor),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
