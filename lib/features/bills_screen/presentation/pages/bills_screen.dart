import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';
import '../widgets/billDetails.dart';
import '../widgets/billing_filter.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  List<Map<String, dynamic>> bills = [
    {
      "id": "INV-2025001",
      "title": "كافور",
      "amount": "3,500",
      "tax": "150",
      "date": "25 يناير 2025",
      "category": "مشتريات",
      "merchant": "كافور مول",
      "qrData": "فاتورة كافور - رقم INV-2025001",
      "warrantyType": "ضمان سنة",
      "warrantyEndDate": "25 يناير 2026",
      "warrantyStatus": "ساري"
    },
    {
      "id": "INV-2025002",
      "title": "فاتورة الكهرباء",
      "amount": "300",
      "tax": "20",
      "date": "25 يناير 2025",
      "category": "مرافق عامة",
      "merchant": "شركة الكهرباء",
      "qrData": "فاتورة كهرباء - رقم INV-2025002",
      "warrantyType": "لا يوجد",
      "warrantyEndDate": "-",
      "warrantyStatus": "-"
    },
    {
      "id": "INV-2025003",
      "title": "إيجار المنزل",
      "amount": "800",
      "tax": "0",
      "date": "25 يناير 2025",
      "category": "إيجارات",
      "merchant": "مالك العقار",
      "qrData": "إيجار منزل - رقم INV-2025003",
      "warrantyType": "لا يوجد",
      "warrantyEndDate": "-",
      "warrantyStatus": "-"
    }
  ];

  List<Map<String, dynamic>> filteredBills = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBills = bills;
    searchController.addListener(_filterBills);
  }

  void _filterBills() {
    setState(() {
      filteredBills = bills.where((bill) {
        return bill["title"].contains(searchController.text);
      }).toList();
    });
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BillsFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "فواتيري",
          style: TextStyle(color: ColorManger.blackColor),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () => openFilterSheet(),
                    icon: Icon(Icons.filter_list)),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: " ابحث عن فاتورة...",
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredBills.length,
        itemBuilder: (context, index) {
          final bill = filteredBills[index];
          return Dismissible(
            key: Key(bill['title']),
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.delete, color: Colors.white))),
            onDismissed: (direction) => setState(() => bills.removeAt(index)),
            child: ListTile(
              title: Text(bill["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bill["date"]),
              trailing: Text("${bill["amount"]} ريال",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              onTap: () => Constants.navigateTo(
                context,
                BillDetailsScreen(bill: bill),
              ),
            ),
          );
        },
      ),
    );
  }
}
