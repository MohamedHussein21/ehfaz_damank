import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';

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
    return GestureDetector(
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
    );
  }
}

class LastBillsAdded extends StatelessWidget {
  const LastBillsAdded({super.key});

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
      appBar: Constants.defaultAppBar(
        context,
        txt: "last bills Added".tr(),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            return invoices[index];
          }),
    );
  }
}
