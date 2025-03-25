import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../data/models/home_model.dart';

class LastBillsCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const LastBillsCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: () {},
        child: Card(
          color: ColorManger.wightColor,
          child: ListTile(
            title: Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(date),
            trailing: Text(amount,
                style: TextStyle(
                  fontSize: 16,
                )),
          ),
        ),
      ),
    );
  }
}

class LastBillsAdded extends StatelessWidget {
  final OrdersResponse? ordersResponse;

  const LastBillsAdded({super.key, this.ordersResponse});

  @override
  Widget build(BuildContext context) {
    final invoices = ordersResponse!.orders.map((order) {
      return LastBillsCard(
        title: order.name ?? '',
        amount: "${order.price} ريال",
        date: order.purchaseDate ?? '',
      );
    }).toList();

    return Scaffold(
      appBar: Constants.defaultAppBar(
        context,
        txt: "last bills Added".tr(),
      ),
      body: invoices.isEmpty
          ? Center(child: Text("لا يوجد فواتير متاحة"))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                return invoices[index];
              }),
    );
  }
}
