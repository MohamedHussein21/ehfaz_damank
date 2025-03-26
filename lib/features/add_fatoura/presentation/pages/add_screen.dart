import 'dart:io';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/icons_assets.dart';
import '../widgets/invoice_category_selector .dart';

class AddNewBill extends StatefulWidget {
  const AddNewBill({super.key});

  @override
  _AddNewBillState createState() => _AddNewBillState();
}

class _AddNewBillState extends State<AddNewBill> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final statusController = TextEditingController();
  final merchantController = TextEditingController();
  final qrDataController = TextEditingController();
  final warrantyEndDateController = TextEditingController();
  final warrantyNoteController = TextEditingController();
  final storeController = TextEditingController();
  final invoiceNumberController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final reminderController = TextEditingController();
  int? selectedCategoryId;
  bool includesWarranty = false;

  int dman = 1;
  String? selectedReminder;
  XFile? selectedImage;
  String? selectedFile;
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

  Widget buildUploadSection() {
    return GestureDetector(
      onTap: showImagePicker,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: selectedImage != null
            ? Image.file(
                File(selectedImage!.path),
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
                    selectedFile != null
                        ? "تم اختيار ملف: ${selectedFile!.split('/').last}"
                        : "قم برفع صورة أو مستند الفاتورة",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddFatouraCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("إضافة فاتورة جديدة"),
        ),
        body: BlocConsumer<AddFatouraCubit, AddFatouraState>(
          listener: (context, state) {
            if (state is AddFatouraSuccess) {
              Constants.defaultDialog(
                context: context,
                image: IconsAssets.done,
                title: "تم حفظ الفاتورة بنجاح",
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
                      Navigator.pop(context);
                    },
                    child: const Text("العودة إلى الرئيسية"),
                  ),
                ],
              );
            } else if (state is AddFatouraError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AddFatouraLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Constants.buildTextFormField(
                      "اسم الفاتورة / المنتج",
                      titleController,
                      'iPhone 15 Pro',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم الفاتورة / المنتج';
                        }
                        return null;
                      },
                    ),
                    Constants.buildTextFormField(
                      "المبلغ المدفوع",
                      amountController,
                      "3500",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال المبلغ المدفوع';
                        }
                        String numericValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (numericValue.isEmpty ||
                            int.tryParse(numericValue) == null) {
                          return 'يرجى إدخال مبلغ صالح';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () => pickDate(purchaseDateController),
                      child: AbsorbPointer(
                        child: Constants.buildTextFormField(
                          "تاريخ الشراء",
                          purchaseDateController,
                          "YYYY-MM-DD",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال تاريخ الشراء';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Constants.buildTextFormField(
                      "اسم المتجر",
                      merchantController,
                      "جرير",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم المتجر';
                        }
                        return null;
                      },
                    ),
                    Constants.buildTextFormField(
                      "رقم الفاتورة",
                      invoiceNumberController,
                      "123456",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الفاتورة';
                        }
                        return null;
                      },
                    ),
                    const Text("حدد الفئة"),
                    const SizedBox(height: 10),
                    InvoiceCategorySelector(
                      onCategorySelected: (category) {
                        setState(() => selectedCategoryId = category);
                      },
                    ),
                    GestureDetector(
                      onTap: () => pickDate(warrantyEndDateController),
                      child: AbsorbPointer(
                        child: Constants.buildTextFormField(
                          "تاريخ انتهاء الضمان",
                          warrantyEndDateController,
                          "YYYY-MM-DD",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال تاريخ انتهاء الضمان';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    buildUploadSection(),
                    SizedBox(height: 16),
                    Text("هل الفاتورة تشمل ضمان؟ (اختياري)"),
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
                    SizedBox(height: 16),
                    Text("تفعيل تذكير بانتهاء الضمان قبل..."),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        buildReminderChip("يوم", 1),
                        buildReminderChip("أسبوع", 7),
                        buildReminderChip("شهر", 30),
                        buildReminderChip("لا تذكير", 0),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Constants.buildTextFormField(
                      "إضافة ملاحظة عن الفاتورة (اختياري)",
                      warrantyNoteController,
                      "الضمان لمدة سنة يغطي الأعطال فقط",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedCategoryId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('يرجى اختيار الفئة')),
                            );
                            return;
                          }
                          context.read<AddFatouraCubit>().addFatoura(
                                categoryd: selectedCategoryId!,
                                name: titleController.text,
                                storeName: merchantController.text,
                                purchaseDate: purchaseDateController.text,
                                fatoraNumber: invoiceNumberController.text,
                                daman: dman,
                                damanDate: warrantyEndDateController.text,
                                notes: warrantyNoteController.text,
                                image: selectedImage,
                                price: int.tryParse(amountController.text) ?? 0,
                                reminder: selectedReminderValue,
                              );
                        }
                      },
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
            );
          },
        ),
      ),
    );
  }

  Widget buildChoiceChip(String label, bool value) {
    return ChoiceChip(
      label: Text(label),
      selected: includesWarranty == value,
      selectedColor: ColorManger.defaultColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: includesWarranty == value ? Colors.white : Colors.black,
      ),
      onSelected: (selected) {
        setState(() {
          includesWarranty = value;
        });
      },
    );
  }

  int selectedReminderValue = 0;

  Widget buildReminderChip(String label, int value) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedReminderValue == value,
      selectedColor: ColorManger.defaultColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selectedReminderValue == value ? Colors.white : Colors.black,
      ),
      onSelected: (selected) {
        setState(() {
          selectedReminderValue = value;
        });
      },
    );
  }
}
