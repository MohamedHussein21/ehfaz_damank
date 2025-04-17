import 'dart:io';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/bills_screen/data/models/bills_model.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_state.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';

import '../../../add_fatoura/data/models/categoris_model.dart';
import '../../../main/presentation/pages/main_screen.dart';

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
  final List<String> reminderOptions = [
    "day".tr(),
    "week".tr(),
    "month".tr(),
    "no reminder".tr(),
  ];
  XFile? selectedImage;
  String? selectedFile;
  int dman = 0;
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

  final _formKey = GlobalKey<FormState>();

  // Validate and save bill
  void saveBill() {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all required fields".tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update local bill object
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
    });

    // Call the edit method - navigation is handled in the BlocListener
    context.read<BillsScreenCubit>().editBill(
          categoryId: int.tryParse(categoryController.text) ?? 0,
          price: int.tryParse(amountController.text) ?? 0,
          name: titleController.text,
          storeName: merchantController.text,
          purchaseDate: dateController.text,
          fatoraNumber: fatoraNumberController.text,
          daman: dman,
          damanReminder: selectedReminderValue ?? 0,
          damanDate: warrantyEndDateController.text,
          notes: warrantyNoteController.text,
          orderId: widget.bill.id ?? 0,
        );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        imageQuality: 40,
        maxWidth: 1000,
      );
      if (image != null) {
        setState(() {
          selectedImage = image;
          selectedFile = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"error select image".tr()} $e")),
      );
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
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
                  Icon(Icons.cloud_upload,
                      size: 40, color: ColorManger.defaultColor),
                  Text("Upload an image or invoice document".tr(),
                      textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("take photo".tr()),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("choose from gallery".tr()),
            onTap: () {
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: Icon(Icons.insert_drive_file),
            title: Text("choose file".tr()),
            onTap: () {
              Navigator.pop(context);
              pickFile();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<BillsScreenCubit>()),
        BlocProvider(create: (_) => AddFatouraCubit()..getCategoris()),
      ],
      child: BlocBuilder<AddFatouraCubit, AddFatouraState>(
        builder: (context, addFatouraState) {
          final addCubit = AddFatouraCubit.get(context);
          final categories = addCubit.categoryModel ?? [];

          return BlocConsumer<BillsScreenCubit, BillsScreenState>(
            listener: (context, state) {
              if (state is EditFatouraSuccus) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Bill updated successfully".tr()),
                    backgroundColor: Colors.green,
                  ),
                );

                Constants.navigateTo(context, MainScreen());
              } else if (state is EditFatouraError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      "Edit Bill".tr(),
                      style: TextStyle(color: ColorManger.blackColor),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: ColorManger.blackColor,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTextField("bill name / product name".tr(),
                                titleController,
                                isRequired: true),
                            buildTextField("price paid".tr(), amountController,
                                isRequired: true),
                            GestureDetector(
                              child: AbsorbPointer(
                                child: buildTextField(
                                    "date of purchase".tr(), dateController),
                              ),
                            ),
                            buildTextField(
                                "store name".tr(), merchantController),
                            buildTextField(
                                "fatora number".tr(), fatoraNumberController),
                            Text("category".tr()),
                            const SizedBox(height: 10),
                            CategoryPicker(
                              controller: categoryController,
                              categories: categories,
                            ),
                            GestureDetector(
                              onTap: () => pickDate(warrantyEndDateController),
                              child: AbsorbPointer(
                                child: buildTextField("warranty end date".tr(),
                                    warrantyEndDateController),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text("warranty included(optional)".tr()),
                            Row(
                              children: [
                                Text("yes".tr()),
                                Radio(
                                    value: 1,
                                    groupValue: dman,
                                    onChanged: (value) {
                                      setState(() => dman = value as int);
                                    }),
                                Text("no".tr()),
                                Radio(
                                    value: 0,
                                    groupValue: dman,
                                    onChanged: (value) {
                                      setState(() => dman = value as int);
                                    }),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text("enable reminder before expiration".tr()),
                            Wrap(
                              spacing: 8.0,
                              children: reminderOptions
                                  .map((option) => buildReminderChip(
                                      option, reminderOptions.indexOf(option)))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            buildTextField("add bill note(optional)".tr(),
                                warrantyNoteController),
                            const SizedBox(height: 20),
                            // Save button with loading state handling
                            state is EditFatouraLouding
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorManger.defaultColor,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: saveBill,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorManger.defaultColor,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    child: Text("save".tr(),
                                        style: TextStyle(color: Colors.white)),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isRequired ? "$label *" : label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required".tr();
                  }
                  return null;
                }
              : null,
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
  final List<CategoryModel> categories;

  const CategoryPicker({
    super.key,
    required this.controller,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCategoryId = int.tryParse(controller.text);
    final currentCategory = categories.firstWhere(
      (cat) => cat.id == selectedCategoryId,
      orElse: () => CategoryModel(
        id: 0,
        name: "غير محدد",
        image: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalOrdersAmount: 0,
      ),
    );

    return DropdownButtonFormField<CategoryModel>(
      value: currentCategory,
      decoration: InputDecoration(
        labelText: "choose category".tr(),
        border: OutlineInputBorder(),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<CategoryModel>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          controller.text = value.id.toString();
        }
      },
    );
  }
}
