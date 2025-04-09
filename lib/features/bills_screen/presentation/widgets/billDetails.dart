import 'dart:io';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_state.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/widgets/edit_bills.dart';
import 'package:ahfaz_damanak/features/main/presentation/pages/main_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/icons_assets.dart';
import '../../data/models/bills_model.dart';

class BillDetailsScreen extends StatelessWidget {
  final Bill bill;

   BillDetailsScreen({super.key, required this.bill});

final List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "إلكترونيات"},
    {"id": 2, "name": "أجهزة منزلية"},
    {"id": 3, "name": "ادوات صحية"},
    {"id": 4, "name": "سيارات"},
    {"id": 5, "name": "ادوات كهربائية"},
     {"id": 6, "name": "اخري"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillsScreenCubit, BillsScreenState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        DateTime? damanDate = DateTime.tryParse(bill.damanDate ?? '');
  try {
    damanDate = DateFormat("yyyy-MM-dd").parse(bill.damanDate ?? '');
  } catch (e) {
  }

  DateTime now = DateTime.now();
  DateTime threeMonthsLater = now.add(const Duration(days: 90)); 

  bool isExpired = (damanDate != null && damanDate.isBefore(now)); 
  bool isLessThanThreeMonths = (damanDate != null && damanDate.isBefore(threeMonthsLater) && damanDate.isAfter(now)); 

  Color dateColor = isExpired || isLessThanThreeMonths ? Colors.red : Colors.green;
  TextDecoration textDecoration = isExpired ? TextDecoration.lineThrough : TextDecoration.none;
 
        return Scaffold(
          appBar: AppBar(
            title: Text("تفاصيل الفاتورة",
                style: TextStyle(color: ColorManger.blackColor)),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: ColorManger.blackColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Constants.defaultDialog(
                      context: context,
                      image: IconsAssets.delet,
                      title: "هل تريد حذف الفاتورة؟",
                      action: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManger.defaultColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("إلغاء"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: ColorManger.defaultColor),
                            foregroundColor: ColorManger.defaultColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          onPressed: () {
                            final cubit = context.read<BillsScreenCubit>();
                            cubit.deleteBill(id: bill.id.toString());
     
                            if(state is GetFilterSuccus){
                         ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('تم حذف الفاتورة بنجاح'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
                               Constants.navigateAndFinish(context, MainScreen());

                            }

                          },
                          child: const Text("حذف"),
                        ),
                      ]);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'كود الفاتورة',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Center(
                  child: QrImageView(
                    data: bill.id.toString(),
                    size: 150,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("بيانات الفاتورة"),
                _buildDetailRow("اسم الفاتورة /المنتج", bill.name ?? ''),
                _buildDetailRow("تاريخ الشراء", bill.purchaseDate ?? ''),
                _buildDetailRow("المبلغ المدفوع", "${bill.price} ريال"),
                _buildDetailRow("جهة الشراء", bill.storeName ?? ''),
                _buildDetailRow(
                  "الفئة",
                  categories.firstWhere(
                    (category) => category['id'] == bill.categoryId,
                    orElse: () => {"name": "غير محدد"},
                  )['name'],
                ),
                _buildDetailRow("رقم الفاتورة", bill.fatoraNumber ?? ''),
                const SizedBox(height: 20),
                _buildSectionTitle("تفاصيل الضمان والصيانة"),
                _buildDetailRow(
                    "هل الفاتورة تشمل ضمان؟", bill.daman ==0 ?'لا':'نعم'),
                _buildDetailRow("نهاية الضمان", bill.damanDate ?? '',
                    valueColor: dateColor, textDecoration: textDecoration),
                _buildDetailRow("تنبيه بانتهاء الضمان",
                    bill.damanReminder?.toString() ?? ''),
                const SizedBox(height: 20),
                _buildSectionTitle("المرفقات والمستندات"),
                Row(
                  children: [
                    if (bill.image != null) ...[
                      if (bill.image!.toLowerCase().endsWith('.pdf'))
                        _buildAttachment(
                            icon: Icons.picture_as_pdf,
                            label: "PDF",
                            filePath: bill.image!,
                            context: context),
                      if (bill.image!.toLowerCase().endsWith('.png') || bill.image!.toLowerCase().endsWith('.jpg'))
                        _buildAttachment(
                            icon: Icons.image,
                            label: "صورة",
                            filePath: bill.image!
                            ,
                            context: context),
                      if (!bill.image!.toLowerCase().endsWith('.pdf') &&
                          !bill.image!.toLowerCase().endsWith('.png') &&
                          !bill.image!.toLowerCase().endsWith('.jpg'))
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "صيغة الملف غير مدعومة",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "لا يوجد مرفقات",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          shareBillAsPDF();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.defaultColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text("مشاركة",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                      width: MediaQueryValue(context).width * 0.12,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Constants.navigateTo(
                              context,
                              EditBillScreen(
                                bill: bill,
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.wightColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(Icons.edit, color: ColorManger.defaultColor),
                        label: Text("تعديل",
                            style: TextStyle(
                                color: ColorManger.defaultColor, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> shareBillAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("تفاصيل الفاتورة",
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("اسم الفاتورة /المنتج: ${bill.name ?? ''}"),
            pw.Text("تاريخ الشراء: ${bill.purchaseDate ?? ''}"),
            pw.Text("المبلغ المدفوع: ${bill.price} ريال"),
            pw.Text("جهة الشراء: ${bill.storeName ?? ''}"),
            pw.Text("الفئة: ${bill.categoryId?.toString() ?? ''}"),
            pw.Text("رقم الفاتورة: ${bill.fatoraNumber ?? ''}"),
            pw.Text("هل الفاتورة تشمل ضمان؟: ${bill.daman?.toString() ?? ''}"),
            pw.Text("نهاية الضمان: ${bill.damanDate ?? ''}"),
            pw.Text(
                "تنبيه بانتهاء الضمان: ${bill.damanReminder?.toString() ?? ''}"),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/bill.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)], text: "تفاصيل الفاتورة");
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow(String title, String value, {Color? valueColor,  TextDecoration? textDecoration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style:
                  TextStyle(fontSize: 16, color: valueColor ?? Colors.black)),
        ],
      ),
    );
  }

  Widget _buildAttachment(
      {required IconData icon,
      required String label,
      required String filePath,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            if (filePath.toLowerCase().endsWith('.pdf')) {
              // Display PDF in a popup
              return AlertDialog(
                content: Text("عرض ملفات PDF غير مدعوم حالياً."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إغلاق"),
                  ),
                ],
              );
            } else {
              // Display image in a popup
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.file(File(filePath)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("إغلاق"),
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 40, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}




