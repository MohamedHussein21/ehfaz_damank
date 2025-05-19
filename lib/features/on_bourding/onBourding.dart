import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/helper/cash_helper.dart';
import '../../core/storage/hive_helper.dart';
import '../../core/utils/color_mange.dart';
import '../../core/utils/constant.dart';
import '../../core/utils/images_mange.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: ImageAssets.onboarding2,
      title: "onboarding_title_1".tr(),
      body: "onboarding_body_1".tr(),
    ),
    BoardingModel(
      image: ImageAssets.onboarding3,
      title: "onboarding_title_2".tr(),
      body: "onboarding_body_2".tr(),
    ),
    BoardingModel(
      image: ImageAssets.onboarding3,
      title: "onboarding_title_3".tr(),
      body: "onboarding_body_3".tr(),
    ),
  ];

  bool isFirst = true;
  bool isLast = false;

  var boardingController = PageController();

  void submit() {
    HiveHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if (value) {
        Constants.navigateAndFinish(context, const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: MediaQueryValue(context).heigh * 0.1,
          leading: TextButton(
              onPressed: submit,
              child: Text(
                'Skip'.tr(),
                style: TextStyle(color: ColorManger.defaultColor),
              ))),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                controller: boardingController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildBoarding(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardingController.nextPage(
                        duration: const Duration(milliseconds: 720),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: isLast ? Text('start'.tr()) : Text('Next'.tr()),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    boardingController.previousPage(
                        duration: const Duration(milliseconds: 720),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: isFirst
                      ? const SizedBox()
                      : Text(
                          'previous'.tr(),
                        ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildBoarding(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              textAlign: TextAlign.center,
              model.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: MediaQueryValue(context).heigh * 0.1,
          ),
          Expanded(child: Image.asset(model.image)),
          SizedBox(
            height: MediaQueryValue(context).heigh * 0.1,
          ),
          Center(
            child: Text(
              textAlign: TextAlign.center,
              model.body,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      );
}
