import 'package:flutter/material.dart';

class InvoiceCategorySelector extends StatefulWidget {
  final Function(int) onCategorySelected;
  const InvoiceCategorySelector({super.key, required this.onCategorySelected});

  @override
  _InvoiceCategorySelectorState createState() =>
      _InvoiceCategorySelectorState();
}

class _InvoiceCategorySelectorState extends State<InvoiceCategorySelector> {
  int? categoryId;
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "إلكترونيات"},
    {"id": 2, "name": "أجهزة منزلية"},
    {"id": 3, "name": "ملابس"},
    {"id": 4, "name": "سيارات"},
    {"id": 5, "name": "أخرى"},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "حدد الفئة",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedCategory,
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category["name"],
          child: Text(category["name"]),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
          categoryId = categories
              .firstWhere((category) => category["name"] == value)["id"];
        });
        widget.onCategorySelected(categoryId!);
      },
    );
  }
}
