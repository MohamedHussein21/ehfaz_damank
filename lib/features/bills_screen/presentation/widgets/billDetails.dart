import 'dart:io';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/widgets/edit_bills.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/icons_assets.dart';

class BillDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bill;

  const BillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
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
                data: bill["qrData"] ?? "فاتورة رقم ${bill["id"]}",
                size: 150,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("بيانات الفاتورة"),
            _buildDetailRow("اسم الفاتورة /المنتج", bill["title"]),
            _buildDetailRow("تاريخ الشراء", bill["date"]),
            _buildDetailRow(" المبلغ المدفوع", "${bill["amount"]} ريال"),
            _buildDetailRow("جهة الشراء ", bill["merchant"]),
            _buildDetailRow("الفئة", bill["category"]),
            _buildDetailRow("رقم الفاتورة", bill["id"]),
            const SizedBox(height: 20),
            _buildSectionTitle("تفاصيل الضمان والصيانة"),
            _buildDetailRow(" هل الفاتورة تشمل ضمان ؟", bill["warrantyType"]),
            _buildDetailRow(" نهاسة الضمان ", bill["warrantyEndDate"],
                valueColor: Colors.red),
            _buildDetailRow("تنبيه بانتهاء الضمان ", bill["warrantyStatus"]),
            const SizedBox(height: 20),
            _buildSectionTitle("المرفقات والمستندات"),
            Row(
              children: [
                _buildAttachment(icon: Icons.picture_as_pdf, label: "PDF"),
                const SizedBox(width: 10),
                _buildAttachment(icon: Icons.image, label: "صورة"),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManger.defaultColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text("مشاركة",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _buildDetailRow(String title, String value, {Color? valueColor}) {
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

  Widget _buildAttachment({required IconData icon, required String label}) {
    return Column(
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
    );
  }
}
