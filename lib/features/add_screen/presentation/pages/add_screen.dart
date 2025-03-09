import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/add_screen/presentation/widgets/widgeta.dart';
import 'package:ahfaz_damanak/features/home_screen/presentation/pages/home_screen.dart';
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/icons_assets.dart';

class AddNewBill extends StatefulWidget {
  const AddNewBill({super.key});

  @override
  _AddNewBillState createState() => _AddNewBillState();
}

class _AddNewBillState extends State<AddNewBill> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final categoryController = TextEditingController();
  final statusController = TextEditingController();
  final merchantController = TextEditingController();
  final qrDataController = TextEditingController();
  final warrantyEndDateController = TextEditingController();
  final warrantyNoteController = TextEditingController();

  bool includesWarranty = false;
  String? selectedReminder;
  XFile? selectedImage;

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = image;
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
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إضافة فاتورة"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Constants.buildTextField(
                "اسم الفاتورة / المنتج", titleController, 'ايفون 15 برو '),
            Constants.buildTextField(
                "المبلغ المدفوع", amountController, "3,500 ريال"),
            Constants.buildTextField(
                "تاريخ الشراء", dateController, "DD/MM/YY"),
            Constants.buildTextField("اسم المتجر", merchantController, "جرير"),
            buildInvoiceNumberField(),
            _buildDropdownField("حدد الفئة", ["إلكترونيات", "أثاث", "ملابس"]),
            buildUploadSection(),
            SizedBox(height: 16),
            Text("هل الفاتورة تشمل ضمان؟ (اختياري)"),
            Row(
              children: [
                buildChoiceChip("لا", false),
                SizedBox(width: 10),
                buildChoiceChip("نعم", true),
              ],
            ),
            SizedBox(height: 16),
            Text("تفعيل تذكير بانتهاء الضمان قبل..."),
            Wrap(
              spacing: 8.0,
              children: [
                buildReminderChip("يوم"),
                buildReminderChip("أسبوع"),
                buildReminderChip("شهر"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Constants.buildTextField(
                "تاريخ انتهاء الضمان ", titleController, "DD/MM/YY"),
            Constants.buildTextField("اضافة ملاحظة عن الفاتورة (اختياري)",
                titleController, ' الضمان لمده سنه يغطي الاعطال فقط   '),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Constants.defaultDialog(
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
                        Constants.navigateAndFinish(context, MainScreen());
                      },
                      child: const Text("العودة الي الصفحه الرئيسية"),
                    ),
                  ]),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManger.defaultColor,
                  minimumSize: Size(double.infinity, 50)),
              child: const Text(
                "حفظ ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    String? selectedItem;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (value) {
          setState(() => selectedItem = value);
        },
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

  Widget buildReminderChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedReminder == label,
      selectedColor: ColorManger.defaultColor,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selectedReminder == label ? Colors.white : Colors.black,
      ),
      onSelected: (selected) {
        setState(() {
          selectedReminder = label;
        });
      },
    );
  }
}
