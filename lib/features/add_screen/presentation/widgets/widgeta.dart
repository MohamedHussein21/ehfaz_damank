import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';

bool includesWarranty = false;
String? selectedReminder;

Widget buildTextField(String label, String hint) {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget buildInvoiceNumberField() {
  return Padding(
    padding: EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: "رقم الفاتورة",
        suffixIcon: IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () => showTimePicker,
        ),
        border: OutlineInputBorder(),
      ),
    ),
  );
}

Widget buildUploadSection() {
  return GestureDetector(
    onTap: () => showTimePicker,
    child: Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload,
            size: 40,
            color: ColorManger.defaultColor,
          ),
          Text("قم برفع صورة أو مستند الفاتورة"),
        ],
      ),
    ),
  );
}
