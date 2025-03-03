import 'package:ahfaz_damanak/features/login/presentation/pages/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/helper/cash_helper.dart';
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
      image: ImageAssets.onboarding1,
      title: 'وداعًا لفقدان الفواتير!',
      body: '''احفظ فواتيرك إلكترونيًا، ونظّمها بسهولة في مكان
           آمن، للوصول إليها وقتما تحتاج.''',
    ),
    BoardingModel(
      image: ImageAssets.onboarding2,
      title: 'إشعارات ذكية تُبقيك على اطلاع دائم!',
      body: ''' سنذكّرك بمواعيد انتهاء الضمان، تواريخ السداد،
       وجدولة الصيانة حتى لا تفوتك أي تفاصيل مهمة..
 ''',
    ),
    BoardingModel(
      image: ImageAssets.onboarding3,
      title: 'تحليلات وتقارير مالية دقيقة!',
      body: '''استعرض ملخصات شهرية، وتتبّع إنفاقك من خلال 
          تقارير ذكية تساعدك على إدارة ميزانيتك بفعالية..''',
    ),
    BoardingModel(
      image: ImageAssets.onboarding3,
      title: 'بياناتك بأمان دائمًا!',
      body: '''نحفظ فواتيرك بتشفير قوي، مع مزامنة سحابية
           تتيح لك الوصول إليها من أي جهاز بكل أمان..''',
    ),
  ];

  bool isLast = false;
  String next = 'Next'.tr();

  var boardingController = PageController();

  void submit() {
    CashHelper.saveData(key: 'OnBoarding', value: true).then((value) {
      if (value) {
        Constants.navigateAndFinish(context, const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: submit,
              child: Text(
                'Skip'.tr(),
                style: TextStyle(color: ColorManger.defaultColor),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
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
                    boardingController.previousPage(
                        duration: const Duration(milliseconds: 720),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: Text(
                    'previous'.tr(),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                      next = ' Start'.tr();
                    }
                    boardingController.nextPage(
                        duration: const Duration(milliseconds: 720),
                        curve: Curves.fastLinearToSlowEaseIn);
                  },
                  child: Text(
                    next.tr(),
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
          const SizedBox(
            height: 20,
          ),
          Expanded(child: Image.asset(model.image)),
          const SizedBox(
            height: 30,
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
