import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String image;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.value,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorManger.blackColor,
          width: 0.5,
        ),
        color: ColorManger.wightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.29,
      child: Column(
        children: [
          Image(image: AssetImage(image), height: 30),
          SizedBox(height: 10),
          Text(title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          Spacer(),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.purple)),
        ],
      ),
    );
  }
}
