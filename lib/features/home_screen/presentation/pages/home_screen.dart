import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/icons_assets.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/home_screen/presentation/widgets/warrantyItem.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_screen_cubit.dart';
import '../widgets/build_drawer.dart';
import '../widgets/last_bills_card.dart';
import '../widgets/sammery_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..getData(),
      child: Scaffold(
        drawer: BuildDrawer(),
        backgroundColor: Colors.white,
        body: BlocConsumer<HomeScreenCubit, HomeScreenState>(
          listener: (context, state) {
            if (state is HomeScreenError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is HomeScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeScreenSuccess) {
              final ordersResponse = state.ordersResponse;

              final invoices = ordersResponse.orders.map((order) {
                return LastBillsCard(
                  title: order.name ?? '',
                  amount: "${order.price} ${"riyal".tr()}",
                  date: order.damanDate ?? '',
                );
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(100),
                          bottomEnd: Radius.circular(100)),
                    ),
                    backgroundColor: ColorManger.defaultColor,
                    pinned: true,
                    expandedHeight: 150.0,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      titlePadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, right: 25, left: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${"hallo".tr()} 👋',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorManger.wightColor,
                              ),
                            ),
                            SizedBox(
                                height: MediaQueryValue(context).heigh * 0.005),
                            Text(
                              "save your bills, follow your warranties".tr(),
                              style: TextStyle(
                                fontSize: 13,
                                color: ColorManger.wightColor.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SummaryCard(
                                  image: IconsAssets.allInvoice,
                                  title: "total Bills".tr(),
                                  value: ordersResponse.countOrders.toString(),
                                ),
                                SizedBox(
                                    width:
                                        MediaQueryValue(context).width * 0.04),
                                SummaryCard(
                                  image: IconsAssets.mony,
                                  title: "total price ",
                                  value:
                                      "${ordersResponse.pricesInMonth.toString()} ${"riyal".tr()}",
                                ),
                                SizedBox(
                                    width:
                                        MediaQueryValue(context).width * 0.04),
                                SummaryCard(
                                  image: IconsAssets.allNote,
                                  title: "Warranties that expire soon".tr(),
                                  value: ordersResponse.expireOrdersInMonth
                                      .toString(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "last bills Added".tr(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  width: MediaQueryValue(context).width * 0.2),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LastBillsAdded(
                                              ordersResponse: ordersResponse,
                                            )),
                                  );
                                },
                                child: Text(
                                  "show more".tr(),
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                ),
                              ),
                              const Icon(
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
                      (context, index) {
                        if (invoices.isEmpty) {
                          return Center(
                            child: Text(
                              'No current bills'.tr(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }
                        return invoices[index];
                      },
                      childCount: invoices.length,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                        top: MediaQueryValue(context).toPadding * 0.7),
                    sliver: SliverToBoxAdapter(
                      child: WarrantySection(
                        ordersResponse: ordersResponse,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Something went wrong!'.tr()));
            }
          },
        ),
      ),
    );
  }
}
