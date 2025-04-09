import 'package:ahfaz_damanak/features/bills_screen/data/models/bills_model.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../cubit/bills_screen_state.dart';

class EditBillScreen extends StatefulWidget {
  final Bill bill;

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
  late TextEditingController fatoraNumberController;
  late TextEditingController warrantyEndDateController;
  late TextEditingController warrantyNoteController;

  bool includesWarranty = false;
  String? selectedReminder;
  final List<String> reminderOptions = ["يوم", "أسبوع", "شهر", "ابدأ"];
  XFile? selectedImage;
  String? selectedFile;
  final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "إلكترونيات"},
    {"id": 2, "name": "أجهزة منزلية"},
    {"id": 3, "name": "ادوات صحية"},
    {"id": 4, "name": "سيارات"},
    {"id": 5, "name": "ادوات كهربائية"},
    {"id": 6, "name": "اخري"},
  ];

  int dman = 0; // 1 for "نعم", 0 for "لا"
  int? selectedReminderValue;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.bill.name);
    amountController =
        TextEditingController(text: widget.bill.price?.toString());
    dateController = TextEditingController(text: widget.bill.purchaseDate);
    categoryController =
        TextEditingController(text: widget.bill.categoryId?.toString());
    statusController =
        TextEditingController(text: widget.bill.daman?.toString());
    merchantController = TextEditingController(text: widget.bill.storeName);
    fatoraNumberController =
        TextEditingController(text: widget.bill.fatoraNumber);
    warrantyEndDateController =
        TextEditingController(text: widget.bill.damanDate);
    warrantyNoteController = TextEditingController(text: widget.bill.notes);
    includesWarranty = widget.bill.daman == 1;
    dman = widget.bill.daman ?? 0;
    selectedReminderValue = widget.bill.damanReminder;
  }

  void saveBill() {
    setState(() {
      widget.bill.name = titleController.text;
      widget.bill.price = int.tryParse(amountController.text);
      widget.bill.purchaseDate = dateController.text;
      widget.bill.categoryId = int.tryParse(categoryController.text);
      widget.bill.daman = dman;
      widget.bill.storeName = merchantController.text;
      widget.bill.fatoraNumber = fatoraNumberController.text;
      widget.bill.damanDate = warrantyEndDateController.text;
      widget.bill.notes = warrantyNoteController.text;
      widget.bill.damanReminder = selectedReminderValue;
      widget.bill.image = selectedImage?.path;
    });

    context.read<BillsScreenCubit>().editBill(
          categoryId: int.tryParse(categoryController.text) ?? 0,
          price: int.tryParse(amountController.text) ?? 0,
          name: titleController.text,
          storeName: merchantController.text,
          purchaseDate: dateController.text,
          fatoraNumber: fatoraNumberController.text,
          image: selectedImage ?? XFile(widget.bill.image ?? ""),
          daman: dman,
          damanReminder: selectedReminderValue ?? 0,
          damanDate: warrantyEndDateController.text,
          notes: warrantyNoteController.text,
          orderId: widget.bill.id ?? 0,
        );
    Navigator.pop(context);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
          source: source, imageQuality: 40, maxWidth: 1000);
      if (image != null) {
        setState(() {
          selectedImage = image;
          selectedFile = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء اختيار الصورة: $e")),
      );
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = result.files.single.path!;
          selectedImage = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء اختيار الملف: $e")),
      );
    }
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd', 'en').format(pickedDate);
      });
    }
  }

  Widget buildUploadSection() {
    return GestureDetector(
      onTap: () => showImagePicker(),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: selectedImage != null || widget.bill.image != null
            ? Image.file(
                File(selectedImage?.path ?? widget.bill.image!),
                fit: BoxFit.cover,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 40,
                    color: ColorManger.defaultColor,
                  ),
                  Text(
                    "قم برفع صورة أو مستند الفاتورة",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("التقاط صورة"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("اختيار من المعرض"),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text("اختيار ملف"),
              onTap: () {
                Navigator.pop(context);
                pickFile();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BillsScreenCubit(),
      child: BlocConsumer<BillsScreenCubit, BillsScreenState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("تعديل الفاتورة"),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField("اسم الفاتورة / المنتج", titleController),
                    buildTextField("المبلغ المدفوع", amountController),
                    GestureDetector(
                      onTap: () => pickDate(dateController),
                      child: AbsorbPointer(
                        child: buildTextField("تاريخ الشراء", dateController),
                      ),
                    ),
                    buildTextField("اسم المتجر", merchantController),
                    buildTextField("رقم الفاتورة", fatoraNumberController),
                    const Text("حدد الفئة"),
                    const SizedBox(height: 10),
                    CategoryPicker(
                      controller: categoryController,
                      categories: categories,
                    ),
                    GestureDetector(
                      onTap: () => pickDate(warrantyEndDateController),
                      child: AbsorbPointer(
                        child: buildTextField(
                            "تاريخ انتهاء الضمان", warrantyEndDateController),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("هل الفاتورة تشمل ضمان؟ (اختياري)"),
                    Row(
                      children: [
                        Text("نعم"),
                        Radio(
                          value: 1,
                          groupValue: dman,
                          onChanged: (value) {
                            setState(() => dman = value as int);
                          },
                        ),
                        Text("لا"),
                        Radio(
                          value: 0,
                          groupValue: dman,
                          onChanged: (value) {
                            setState(() => dman = value as int);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("تفعيل تذكير بانتهاء الضمان قبل..."),
                    Wrap(
                      spacing: 8.0,
                      children: reminderOptions
                          .map((option) => buildReminderChip(
                              option, reminderOptions.indexOf(option)))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    buildTextField("إضافة ملاحظة عن الفاتورة (اختياري)",
                        warrantyNoteController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveBill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.defaultColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "حفظ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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

  Widget buildReminderChip(String label, int value) {
    return ChoiceChip(
      selectedColor: ColorManger.defaultColor,
      backgroundColor: ColorManger.wightColor,
      label: Text(label),
      labelStyle: TextStyle(
        color: selectedReminderValue == value
            ? ColorManger.wightColor
            : ColorManger.blackColor,
      ),
      selected: selectedReminderValue == value,
      onSelected: (selected) {
        setState(() {
          selectedReminderValue = selected ? value : null;
        });
      },
    );
  }
}

class CategoryPicker extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> categories;

  const CategoryPicker({
    super.key,
    required this.controller,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = categories.firstWhere(
      (category) => category['id'] == int.tryParse(controller.text),
      orElse: () => {"name": "غير محدد"},
    )['name'];

    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: const InputDecoration(
        labelText: "اختر الفئة",
        border: OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['name'],
          child: Text(category['name']),
        );
      }).toList(),
      onChanged: (value) {
        controller.text = value ?? '';
      },
    );
  }
}
