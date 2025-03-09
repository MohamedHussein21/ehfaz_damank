import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';

import '../../../../core/utils/color_mange.dart';
import '../../../../core/utils/constant.dart';

class WarrantySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "الضمانات على وشك الانتهاء",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQueryValue(context).width * 0.07,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WarrantyScreen()),
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
        ),
        WarrantyItem(
            device: "آيفون 16 برو ماكس",
            dealer: "Apple",
            expiry: "10 مارس 2026"),
        WarrantyItem(
            device: "Laptop Dell XPS 15",
            dealer: "مكتبة جرير",
            expiry: "3 أشهر"),
      ],
    );
  }
}

class WarrantyItem extends StatelessWidget {
  final String device;
  final String dealer;
  final String expiry;

  const WarrantyItem({
    Key? key,
    required this.device,
    required this.dealer,
    required this.expiry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: ColorManger.wightColor,
        child: ListTile(
          title: Text(device,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Text('الوكيل :$dealer'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ينتهي في '),
              Text(expiry,
                  style: TextStyle(fontSize: 15, color: ColorManger.redColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class WarrantyScreen extends StatelessWidget {
  const WarrantyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.defaultAppBar(
        context,
        txt: "الضمانات على وشك الانتهاء",
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (context, index) {
            return Column(
              children: [
                WarrantyItem(
                    device: "آيفون 16 برو ماكس",
                    dealer: "Apple",
                    expiry: "10 مارس 2026"),
                WarrantyItem(
                    device: "Laptop Dell XPS 15",
                    dealer: "مكتبة جرير",
                    expiry: "3 أشهر"),
              ],
            );
          }),
    );
  }
}
