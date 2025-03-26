import 'package:ahfaz_damanak/core/utils/constant.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/color_mange.dart';
import '../cubit/bills_screen_state.dart';
import '../widgets/billDetails.dart';
import '../widgets/billing_filter.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BillsScreenCubit>().getBills();
    searchController.addListener(_filterBills);
  }

  void _filterBills() {
    if (mounted) {
      setState(() {});
    }
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
    return BlocProvider(
      create: (context) => BillsScreenCubit()..getBills(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My bills".tr(),
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
                      icon: const Icon(Icons.filter_list)),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "search bill....".tr(),
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
        body: BlocBuilder<BillsScreenCubit, BillsScreenState>(
          builder: (context, state) {
            if (state is BillsScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BillsScreenSuccess) {
              final bills = (state.billsModel).where((bill) {
                return (bill.name?.toLowerCase() ?? '')
                    .contains(searchController.text.toLowerCase());
              }).toList();

              if (bills.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد فواتير متاحة'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return Dismissible(
                    key: Key(bill.name ?? ''),
                    background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Icon(Icons.delete, color: Colors.white))),
                    onDismissed: (direction) => context
                        .read<BillsScreenCubit>()
                        .deleteBill(id: bill.id ?? 0),
                    child: ListTile(
                      title: Text(bill.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(bill.purchaseDate ?? ''),
                      trailing: bill.price != null
                          ? Text("${bill.price} ريال",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold))
                          : const SizedBox(),
                      onTap: () => Constants.navigateTo(
                        context,
                        BillDetailsScreen(bill: state.billsModel[index]),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BillsScreenError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No bills found'.tr()));
            }
          },
        ),
      ),
    );
  }
}
