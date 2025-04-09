import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../data/models/home_model.dart';

class LastBillsCard extends StatelessWidget {
  final String title;
  final String amount;
  final String date;

  const LastBillsCard({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
DateTime? damanDate = DateTime.tryParse(date);
try {
  damanDate = DateFormat("yyyy-MM-dd").parse(date.split(' ')[0]);
} catch (e) {
  print("⚠️ خطأ في تحويل التاريخ: $date - $e");
}

    DateTime now = DateTime.now();
    DateTime threeMonthsFromNow = now.add(const Duration(days: 90)); 

    Color dateColor = Colors.grey;
    TextDecoration textDecoration = TextDecoration.none;

    if (damanDate == null) {
      dateColor = Colors.grey;
    } else if (damanDate.isBefore(now)) {
      dateColor = Colors.red;
      textDecoration = TextDecoration.lineThrough;
    } else if (damanDate.isBefore(threeMonthsFromNow)) {
      dateColor = Colors.red;
    } else {
    
      dateColor = Colors.green;
    }

    return SizedBox(
      child: GestureDetector(
        onTap: () {},
        child: Card(
          color: ColorManger.wightColor,
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              date,
              style: TextStyle(
                fontSize: 15,
                color: dateColor,
                decoration: textDecoration, 
              ),
            ),
            trailing: Text(
              amount,
              style: const TextStyle(fontSize: 16),
            ),
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
        date: order.damanDate ?? '',
      );
    }).toList();

    return Scaffold(
      appBar: Constants.defaultAppBar(
        context,
        txt: "last bills Added".tr(),
      ),
      body: invoices.isEmpty
          ? Center(child: Text("لا يوجد فواتير متاحة".tr()))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                return invoices[index];
              },
            ),
    );
  }
}

