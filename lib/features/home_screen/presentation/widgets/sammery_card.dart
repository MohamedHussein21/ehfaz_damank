import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorManger.blackColor,
          width: 0.5,
        ),
        color: ColorManger.wightColor,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.purple)),
        ],
      ),
    );
  }
}
