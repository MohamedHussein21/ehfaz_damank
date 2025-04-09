import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';
import '../../data/models/home_model.dart';

class WarrantySection extends StatelessWidget {
  final OrdersResponse? ordersResponse;

  const WarrantySection({super.key, required this.ordersResponse});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime threeMonthsLater = now.add(const Duration(days: 90));

    final filteredOrders = ordersResponse?.expireOrders.where((order) {
      if (order.damanDate == null) return false;
      
      DateTime? expiryDate = DateTime.tryParse(order.damanDate!);
      if (expiryDate == null) return false;

      return expiryDate.isAfter(now) && expiryDate.isBefore(threeMonthsLater);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guarantees are about to expire'.tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WarrantyScreen(ordersResponse: ordersResponse),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'show more'.tr(),
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (filteredOrders == null || filteredOrders.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "No guarantees expire soon".tr(),
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        else
          ...filteredOrders.take(4).map(
                (order) => WarrantyItem(
                  device: order.name ?? '',
                  dealer: order.storeName ?? '',
                  expiry: order.damanDate ?? '',
                ),
              ),
      ],
    );
  }
}


class WarrantyItem extends StatelessWidget {
  final String device;
  final String dealer;
  final String expiry;

  const WarrantyItem({
    super.key,
    required this.device,
    required this.dealer,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: ColorManger.wightColor,
        child: ListTile(
          title: Text(
            device,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Agent: $dealer'.tr()),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('end in'.tr()),
              Text(
                expiry,
                style: TextStyle(fontSize: 15, color: ColorManger.redColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WarrantyScreen extends StatelessWidget {
  final OrdersResponse? ordersResponse;

  const WarrantyScreen({super.key, required this.ordersResponse});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime threeMonthsLater = now.add(const Duration(days: 90));

    final filteredOrders = ordersResponse?.expireOrders.where((order) {
      if (order.damanDate == null) return false;

      DateTime? expiryDate = DateTime.tryParse(order.damanDate!);
      if (expiryDate == null) return false;

      return expiryDate.isAfter(now) && expiryDate.isBefore(threeMonthsLater);
    }).toList();

    return Scaffold(
      appBar: Constants.defaultAppBar(
        context,
        txt: 'Guarantees are about to expire'.tr(),
      ),
      body: filteredOrders == null || filteredOrders.isEmpty
          ? Center(
              child: Text(
                'No guarantees expire soon'.tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return WarrantyItem(
                  device: order.name ?? '',
                  dealer: order.storeName ?? '',
                  expiry: order.damanDate ?? '',
                );
              },
            ),
    );
  }
}
