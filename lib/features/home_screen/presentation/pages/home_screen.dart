import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/home_screen/presentation/widgets/warrantyItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/built_drawe.dart';
import '../widgets/last_bills_card.dart';
import '../widgets/sammery_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<LastBillsCard> invoices = [
      LastBillsCard(title: "كافور", amount: "3,500 ريال", date: "25 مارس 2025"),
      LastBillsCard(
          title: "فاتورة الكهرباء", amount: "300 ريال", date: "25 مارس 2025"),
      LastBillsCard(
          title: "إيجار المنزل", amount: "800 ريال", date: "25 مارس 2025"),
    ];

    return Scaffold(
      endDrawer: BuiltDrawe(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: SizedBox(),
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(100),
              ),
            ),
            backgroundColor: ColorManger.defaultColor,
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 40.0, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hallo',
                      style: TextStyle(
                          fontSize: 12, color: ColorManger.wightColor),
                    ),
                    SizedBox(height: MediaQueryValue(context).heigh * 0.01),
                    Text(
                      "احفظ فواتيرك، تابع ضمانك!",
                      style: TextStyle(
                          fontSize: 12, color: ColorManger.wightColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SummaryCard(
                            title: "total Bills".tr(), value: "bill".tr()),
                        SizedBox(width: MediaQueryValue(context).width * 0.04),
                        SummaryCard(
                            title: "total price".tr(), value: "reyal".tr()),
                        SizedBox(width: MediaQueryValue(context).width * 0.04),
                        SummaryCard(
                            title: "total price".tr(), value: "reyal".tr()),
                        SizedBox(width: MediaQueryValue(context).width * 0.04),
                        SummaryCard(
                            title: "total price".tr(), value: "reyal".tr()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "last bills Added".tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: MediaQueryValue(context).width * 0.2),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LastBillsAdded()),
                          );
                        },
                        child: Text(
                          "مشاهدة المزيد",
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => invoices[index],
              childCount: invoices.length,
            ),
          ),
          SliverPadding(
            padding:
                EdgeInsets.only(top: MediaQueryValue(context).toPadding * 0.7),
            sliver: SliverToBoxAdapter(
              child: WarrantySection(),
            ),
          ),
        ],
      ),
    );
  }
}
