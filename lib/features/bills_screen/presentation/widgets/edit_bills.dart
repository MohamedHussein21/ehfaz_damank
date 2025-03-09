import 'package:ahfaz_damanak/features/bills_screen/presentation/pages/bills_screen.dart';
import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/icons_assets.dart';

class EditBillScreen extends StatefulWidget {
  final Map<String, dynamic> bill;

  const EditBillScreen({super.key, required this.bill});

  @override
  _EditBillScreenState createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  late TextEditingController categoryController;
  late TextEditingController statusController;
  late TextEditingController merchantController;
  late TextEditingController qrDataController;
  late TextEditingController warrantyEndDateController;
  late TextEditingController warrantyNoteController;

  bool includesWarranty = false;
  String? selectedReminder;
  final List<String> reminderOptions = ["يوم", "أسبوع", "شهر", "ابدأ"];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.bill["title"]);
    amountController = TextEditingController(text: widget.bill["amount"]);
    dateController = TextEditingController(text: widget.bill["date"]);
    categoryController = TextEditingController(text: widget.bill["category"]);
    statusController = TextEditingController(text: widget.bill["status"]);
    merchantController = TextEditingController(text: widget.bill["merchant"]);
    qrDataController = TextEditingController(text: widget.bill["qrData"]);
    warrantyEndDateController =
        TextEditingController(text: widget.bill["warrantyEndDate"]);
    warrantyNoteController =
        TextEditingController(text: widget.bill["warrantyNote"]);
    includesWarranty = widget.bill["includesWarranty"] ?? false;
  }

  void saveBill() {
    setState(() {
      widget.bill["title"] = titleController.text;
      widget.bill["amount"] = amountController.text;
      widget.bill["date"] = dateController.text;
      widget.bill["category"] = categoryController.text;
      widget.bill["status"] = statusController.text;
      widget.bill["merchant"] = merchantController.text;
      widget.bill["qrData"] = qrDataController.text;
      widget.bill["warrantyEndDate"] = warrantyEndDateController.text;
      widget.bill["warrantyNote"] = warrantyNoteController.text;
      widget.bill["includesWarranty"] = includesWarranty;
    });
    Navigator.pop(context, widget.bill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            "تعديل الفاتورة",
            style: TextStyle(color: Colors.black),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("اسم الفاتورة / المنتج", titleController),
              buildTextField("المبلغ المدفوع", amountController),
              buildTextField("تاريخ الشراء", dateController),
              buildTextField("اسم المتجر", merchantController),
              buildTextField("رقم الفاتورة", qrDataController),
              Text('فئة الفاتورة '),
              const SizedBox(height: 8),
              CategoryPicker(controller: categoryController),
              const SizedBox(height: 20),
              _buildWarrantySection(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    Constants.defaultDialog(
                        context: context,
                        image: IconsAssets.done,
                        title: "تم تعديل الفاتورة بنجاح",
                        action: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManger.defaultColor,
                              side: BorderSide(color: ColorManger.defaultColor),
                              foregroundColor: ColorManger.wightColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                            ),
                            onPressed: () {
                              saveBill();
                              Constants.navigateAndFinish(
                                  context, BillsScreen());
                            },
                            child: const Text("العودة الي  الفاتورة"),
                          ),
                        ]);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.defaultColor,
                      foregroundColor: Colors.white),
                  child: const Text("حفظ"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildWarrantySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("هل الفاتورة تشمل ضمان؟"),
        Row(
          children: [
            _buildChoiceChip("نعم", true),
            const SizedBox(width: 10),
            _buildChoiceChip("لا", false),
          ],
        ),
        if (includesWarranty) ...[
          const SizedBox(height: 10),
          const Text("تفعيل تذكير بانتهاء الضمان قبل.."),
          Wrap(
            spacing: 8,
            children: reminderOptions
                .map((option) => _buildReminderChip(option))
                .toList(),
          ),
          buildTextField("تاريخ انتهاء الضمان", warrantyEndDateController),
          buildTextField(
              "إضافة ملاحظة عن الضمان (اختياري)", warrantyNoteController),
        ]
      ],
    );
  }

  Widget _buildChoiceChip(String label, bool value) {
    return ChoiceChip(
      selectedColor: ColorManger.defaultColor,
      backgroundColor: ColorManger.wightColor,
      label: Text(label),
      labelStyle: TextStyle(
        color: includesWarranty == value
            ? ColorManger.wightColor
            : ColorManger.blackColor,
      ),
      selected: includesWarranty == value,
      onSelected: (selected) {
        setState(() {
          includesWarranty = value;
        });
      },
    );
  }

  Widget _buildReminderChip(String label) {
    return ChoiceChip(
      selectedColor: ColorManger.defaultColor,
      backgroundColor: ColorManger.wightColor,
      label: Text(label),
      labelStyle: TextStyle(
        color: label == selectedReminder
            ? ColorManger.wightColor
            : ColorManger.blackColor,
      ),
      selected: selectedReminder == label,
      onSelected: (selected) {
        setState(() {
          selectedReminder = selected ? label : null;
        });
      },
    );
  }
}

class CategoryPicker extends StatelessWidget {
  final TextEditingController controller;

  const CategoryPicker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        suffixIcon: Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(),
      ),
      onTap: () {},
    );
  }
}
