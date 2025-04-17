import 'dart:io';

import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
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
import '../../../add_fatoura/data/models/categoris_model.dart';
import '../../data/models/bills_model.dart';

class BillDetailsScreen extends StatelessWidget {
  final Bill bill;

  BillDetailsScreen({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillsScreenCubit, BillsScreenState>(
      listener: (context, state) {},
      builder: (context, state) {
        DateTime? damanDate = DateTime.tryParse(bill.damanDate ?? '');
        try {
          damanDate = DateFormat("yyyy-MM-dd").parse(bill.damanDate ?? '');
        } catch (e) {}

        DateTime now = DateTime.now();
        DateTime threeMonthsLater = now.add(const Duration(days: 90));

        bool isExpired = (damanDate != null && damanDate.isBefore(now));
        bool isLessThanThreeMonths = (damanDate != null &&
            damanDate.isBefore(threeMonthsLater) &&
            damanDate.isAfter(now));

        Color dateColor =
            isExpired || isLessThanThreeMonths ? Colors.red : Colors.green;
        TextDecoration textDecoration =
            isExpired ? TextDecoration.lineThrough : TextDecoration.none;

        return Scaffold(
          appBar: AppBar(
            title: Text("bill details".tr(),
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
                      title: "do you want to delete the invoice".tr(),
                      action: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManger.defaultColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text("cancel".tr()),
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

                            if (state is GetFilterSuccuss) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text("invoice deleted successfully".tr()),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Constants.navigateAndFinish(
                                  context, MainScreen());
                            }
                          },
                          child: Text("delete".tr()),
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
                  "qr code".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: QrImageView(
                    data: bill.id.toString(),
                    size: 150,
                  ),
                ),
                const SizedBox(height: 30),
                _buildSectionTitle("bill details".tr()),
                const SizedBox(height: 10),
                Card(
                  elevation: 0,
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(children: [
                      _buildDetailRow(
                          "bill name / product name".tr(), bill.name ?? ''),
                      SizedBox(height: 5),
                      _buildDetailRow(
                          "date of purchase".tr(), bill.purchaseDate ?? ''),
                      SizedBox(height: 5),
                      _buildDetailRow("price paid".tr(), "${bill.price} ريال"),
                      SizedBox(height: 5),
                      _buildDetailRow("store name".tr(), bill.storeName ?? ''),
                      SizedBox(height: 5),
                      BlocProvider(
                        create: (context) => AddFatouraCubit()..getCategoris(),
                        child: BlocBuilder<AddFatouraCubit, AddFatouraState>(
                          builder: (context, state) {
                            final addCubit = AddFatouraCubit.get(context);
                            final categories = addCubit.categoryModel ?? [];

                            return _buildDetailRow(
                              "category".tr(),
                              categories
                                  .firstWhere(
                                    (category) =>
                                        category.id == bill.categoryId,
                                    orElse: () => CategoryModel(
                                      id: 0,
                                      name: "غير محدد",
                                      image: "",
                                      createdAt: DateTime.now(),
                                      updatedAt: DateTime.now(),
                                      totalOrdersAmount: 0,
                                    ),
                                  )
                                  .name,
                            );
                          },
                        ),
                      ),
                      _buildDetailRow(
                          "fatura number".tr(), bill.fatoraNumber ?? ''),
                    ]),
                  ),
                ),
                const SizedBox(height: 30),
                _buildSectionTitle("warranty and maintenance details".tr()),
                const SizedBox(height: 10),
                Card(
                  elevation: 0,
                  color: Color(0xFFf5f5f5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDetailRow(
                            "is the invoice covered by warranty?".tr(),
                            bill.daman == 0 ? "no".tr() : "yes".tr()),
                        SizedBox(height: 5),
                        _buildDetailRow(
                            "warranty end".tr(), bill.damanDate ?? '',
                            valueColor: dateColor,
                            textDecoration: textDecoration),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle("attachments and documents".tr()),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (bill.image != null) ...[
                      if (bill.image!.toLowerCase().endsWith('.pdf'))
                        _buildAttachment(
                            icon: Icons.picture_as_pdf,
                            label: "PDF",
                            filePath: bill.image!,
                            context: context),
                      if (bill.image!.toLowerCase().endsWith('.png') ||
                          bill.image!.toLowerCase().endsWith('.jpg'))
                        _buildAttachment(
                            icon: Icons.image,
                            label: "image".tr(),
                            filePath: bill.image!,
                            context: context),
                      if (!bill.image!.toLowerCase().endsWith('.pdf') &&
                          !bill.image!.toLowerCase().endsWith('.png') &&
                          !bill.image!.toLowerCase().endsWith('.jpg'))
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "file format not supported".tr(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "no attachments".tr(),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: Text("share".tr(),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: ColorManger.defaultColor),
                          ),
                        ),
                        icon: Icon(Icons.edit, color: ColorManger.blackColor),
                        label: Text("edit".tr(),
                            style: TextStyle(
                                color: ColorManger.defaultColor, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
            pw.Text("bill details".tr(),
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("${"bill name / product name".tr()} : ${bill.name ?? ''}"),
            pw.Text("${"purchase date".tr()} : ${bill.purchaseDate ?? ''}"),
            pw.Text("${"price paid".tr()} : ${bill.price} ريال"),
            pw.Text("${"store name".tr()} : ${bill.storeName ?? ''}"),
            pw.Text("${"category".tr()} ${bill.categoryId?.toString() ?? ''}"),
            pw.Text(" ${"fatura number".tr()} ${bill.fatoraNumber ?? ''}"),
            pw.Text(
                " ${"is the invoice covered by warranty?".tr()} ${bill.daman?.toString() ?? ''}"),
            pw.Text(" ${"warranty end".tr()} ${bill.damanDate ?? ''}"),
            pw.Text(
                " ${"enable reminder before expiration".tr()} ${bill.damanReminder?.toString() ?? ''}"),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/bill.pdf");
    await file.writeAsBytes(await pdf.save());

    Share.shareXFiles([XFile(file.path)], text: "bill details".tr());
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {Color? valueColor, TextDecoration? textDecoration}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  color: valueColor ?? Colors.black,
                  fontWeight: FontWeight.bold)),
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
                content: Text("PDF file: $filePath"),
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
                      child: Text("close".tr()),
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
