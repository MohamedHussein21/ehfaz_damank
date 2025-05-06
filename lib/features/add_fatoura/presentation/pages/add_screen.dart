import 'dart:convert';
import 'dart:io';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/widgets/qr.dart';
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

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
                        ? "${"selected file".tr()} ${selectedFile!.split('/').last}"
                        : "Upload an image or invoice document".tr(),
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
          title: Text("add new bill".tr()),
          leading: IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Colors.black),
            onPressed: () async {
              String? scannedData = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScannerScreen()),
              );

              if (scannedData == null || scannedData.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No QR code found".tr())),
                );
                return;
              }

              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.compare_arrows),
                          title: Text("Transfer Invoice".tr()),
                          onTap: () {
                            Navigator.pop(context);
                            _handleTransferInvoice(context, scannedData);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.add),
                          title: Text("Add New Invoice".tr()),
                          onTap: () {
                            Navigator.pop(context);
                            _handleAddNewInvoice(context, scannedData);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        body: BlocConsumer<AddFatouraCubit, AddFatouraState>(
          listener: (context, state) {
            if (state is AddFatouraSuccess) {
              Constants.defaultDialog(
                context: context,
                image: IconsAssets.done,
                title: "bill saved successfully".tr(),
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
                      Constants.navigateAndFinish(context, MainScreen());
                    },
                    child: Text("back to home screen".tr()),
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
                      "bill name / product name".tr(),
                      titleController,
                      'iPhone 15 Pro',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter bill name / product name".tr();
                        }
                        return null;
                      },
                    ),
                    Constants.buildTextFormField(
                      "price paid".tr(),
                      amountController,
                      "3500",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter price paid".tr();
                        }
                        String numericValue =
                            value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (numericValue.isEmpty ||
                            int.tryParse(numericValue) == null) {
                          return "please enter valid price".tr();
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () => pickDate(purchaseDateController),
                      child: AbsorbPointer(
                        child: Constants.buildTextFormField(
                          "date of purchase".tr(),
                          purchaseDateController,
                          "YYYY-MM-DD",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter date of purchase".tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Constants.buildTextFormField(
                      "store name".tr(),
                      merchantController,
                      "جرير",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter store name".tr();
                        }
                        return null;
                      },
                    ),
                    Constants.buildTextFormField(
                      "bill number".tr(),
                      invoiceNumberController,
                      "123456",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please enter bill number".tr();
                        }
                        if (!RegExp(r'^[a-zA-Z0-9]{1,10}$').hasMatch(value)) {
                          return "number must be 10 characters or numbers".tr();
                        }
                        return null;
                      },
                    ),
                    Text("select category".tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    InvoiceCategorySelector(
                      categories:
                          context.read<AddFatouraCubit>().categoryModel ?? [],
                      onCategorySelected: (categoryId) {
                        setState(() => selectedCategoryId = categoryId);
                      },
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => pickDate(warrantyEndDateController),
                      child: AbsorbPointer(
                        child: Constants.buildTextFormField(
                          "date of expiration".tr(),
                          warrantyEndDateController,
                          "YYYY-MM-DD",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter date of expiration".tr();
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    buildUploadSection(),
                    SizedBox(height: 16),
                    Text("warranty included(optional)".tr()),
                    Row(
                      children: [
                        Text("yes".tr()),
                        Radio(
                          value: 1,
                          groupValue: dman,
                          onChanged: (value) {
                            setState(() => dman = value as int);
                          },
                        ),
                        Text("no".tr()),
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
                    Text("enable reminder before expiration".tr()),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        buildReminderChip("day".tr(), 1),
                        buildReminderChip("week".tr(), 7),
                        buildReminderChip("month".tr(), 30),
                        buildReminderChip("no reminder".tr(), 0),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Constants.buildTextFormField(
                      "add bill note(optional)".tr(),
                      warrantyNoteController,
                      "warranty for a year only".tr(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedCategoryId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("please select category".tr())),
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
                                price: double.tryParse(amountController.text) ??
                                    0.0,
                                reminder: selectedReminderValue,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManger.defaultColor,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        "save".tr(),
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

  void _handleTransferInvoice(BuildContext context, String scannedData) async {
    try {
      var cubit = context.read<AddFatouraCubit>();

      if (Constants.userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error : user id not found".tr())),
        );
        return;
      }

      int? parsedOrderId = int.tryParse(scannedData);
      if (parsedOrderId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("qr code not valid".tr())),
        );
        return;
      }

      cubit.addFromQr(Constants.userId!, parsedOrderId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("please wait until the transfer request is accepted".tr()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${"qr code not valid".tr()} ${e.toString()}")),
      );
    }
  }

  void _handleAddNewInvoice(BuildContext context, String scannedData) async {
    try {
      var decodedData = ZatcaQrDecoder.decode(scannedData);

      String? rawDate = decodedData['invoiceDate'];
      String formattedDate = '';
      if (rawDate != null && rawDate.isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(rawDate);
          formattedDate = DateFormat('yyyy-MM-dd', 'en_US').format(parsedDate);
        } catch (e) {
          formattedDate = rawDate;
        }
      }

      setState(() {
        titleController.text = decodedData['sellerName'] ?? '';
        merchantController.text = decodedData['sellerName'] ?? '';
        purchaseDateController.text = formattedDate;
        amountController.text = decodedData['invoiceTotal'] ?? '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invoice Data decoded and added to the form!".tr()),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${"failed to decode QR".tr()} ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class ZatcaQrDecoder {
  static Map<String, dynamic> decode(String base64QrCode) {
    Uint8List bytes = base64.decode(base64QrCode);
    Map<String, dynamic> result = {};

    int index = 0;
    int tagNumber = 1;
    while (index < bytes.length) {
      int tag = bytes[index];
      int length = bytes[index + 1];
      Uint8List valueBytes = bytes.sublist(index + 2, index + 2 + length);
      String value = utf8.decode(valueBytes);

      switch (tag) {
        case 1:
          result['sellerName'] = value;
          break;
        case 2:
          result['vatNumber'] = value;
          break;
        case 3:
          result['invoiceDate'] = value;
          break;
        case 4:
          result['invoiceTotal'] = value;
          break;
        case 5:
          result['vatTotal'] = value;
          break;
        default:
          result['tag_$tagNumber'] = value;
      }

      index += 2 + length;
      tagNumber++;
    }

    return result;
  }
}
