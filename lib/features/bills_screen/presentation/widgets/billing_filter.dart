import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';

import '../../../../core/utils/color_mange.dart';

class BillsFilterSheet extends StatefulWidget {
  const BillsFilterSheet({super.key});

  @override
  _BillsFilterSheetState createState() => _BillsFilterSheetState();
}

class _BillsFilterSheetState extends State<BillsFilterSheet> {
  // 🔹 حالة التحديد لكل عنصر
  Map<String, bool> selectedFilters = {
    "سيارات": false,
    "أجهزة منزلية": false,
    "إلكترونيات": false,
    "ملابس": false,
    "التقدم أول": false,
    "الأحدث أول": false,
    "الضمان الأطول مدة": false,
    "الضمان الأقرب للانتهاء": false,
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Text("فلترة الفواتير",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                Text("الفئة",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: ["سيارات", "أجهزة منزلية", "إلكترونيات", "ملابس"]
                      .map((category) => _buildFilterButton(category))
                      .toList(),
                ),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                Text("التاريخ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8,
                  children: ["التقدم أول", "الأحدث أول"]
                      .map((date) => _buildFilterButton(date))
                      .toList(),
                ),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                Text("الضمان",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                Wrap(
                  spacing: 8,
                  children: ["الضمان الأطول مدة", "الضمان الأقرب للانتهاء"]
                      .map((warranty) => _buildFilterButton(warranty))
                      .toList(),
                ),
                SizedBox(height: MediaQueryValue(context).heigh * 0.03),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.defaultColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text("تطبيق",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String title) {
    bool isSelected = selectedFilters[title] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilters[title] = !isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? ColorManger.defaultColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? ColorManger.defaultColor : Colors.grey),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
