import 'dart:developer';

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

    searchController.addListener(() {
      setState(() {});
    });

    context.read<BillsScreenCubit>().getFilter();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BillsScreenCubit>();
    void openFilterSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return BlocProvider.value(
              value: cubit, child: BillsFilterSheet(cubit: cubit));
        },
      );
    }

    return Scaffold(
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
      body: BlocConsumer<BillsScreenCubit, BillsScreenState>(
        buildWhen: (previous, current) {
          return current is GetFilterLouding ||
              current is GetFilterSuccuss ||
              current is GetFilterError;
        },
        listener: (context, state) {
          if (state is GetFilterError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('error get bills'.tr()),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          final fi = context.read<BillsScreenCubit>().filterModel;
          print("fi: $fi");
          if (state is GetFilterLouding) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetFilterSuccuss) {
            log("Current State: $state");

            final bills = (searchController.text.isNotEmpty)
                ? state.filterModel.where((bill) {
                    final query = searchController.text.toLowerCase();
                    final name = bill.name?.toLowerCase() ?? '';
                    final number = bill.fatoraNumber?.toLowerCase() ?? '';
                    return name.contains(query) || number.contains(query);
                  }).toList()
                : state.filterModel;

            if (bills.isEmpty) {
              return Center(
                child: Text('No bills found'.tr()),
              );
            }
            return ListView.builder(
                itemCount: bills.length,
                itemBuilder: (context, index) {
                  final bill = bills[index];

                  DateTime? damanDate = DateTime.tryParse(bill.damanDate ?? '');
                  try {
                    damanDate =
                        DateFormat("yyyy-MM-dd").parse(bill.damanDate ?? '');
                  } catch (e) {}

                  DateTime now = DateTime.now();
                  DateTime threeMonthsLater = now.add(const Duration(days: 90));

                  bool isExpired =
                      (damanDate != null && damanDate.isBefore(now));
                  bool isLessThanThreeMonths = (damanDate != null &&
                      damanDate.isBefore(threeMonthsLater) &&
                      damanDate.isAfter(now));

                  Color dateColor = isExpired || isLessThanThreeMonths
                      ? Colors.red
                      : Colors.green;
                  TextDecoration textDecoration = isExpired
                      ? TextDecoration.lineThrough
                      : TextDecoration.none;

                  return Dismissible(
                    key: Key(bill.name ?? ''),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    onDismissed: (direction) {
                      context
                          .read<BillsScreenCubit>()
                          .deleteBill(id: bill.id.toString());

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('success delete bill'.tr()),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        '${bill.name ?? ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        bill.damanDate ?? 'date not available'.tr(),
                        style: TextStyle(
                          color: dateColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: textDecoration,
                        ),
                      ),
                      trailing: bill.price != null
                          ? Text(
                              "${bill.price} ${"riyal".tr()}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )
                          : const SizedBox(),
                      onTap: () => Constants.navigateTo(
                        context,
                        BillDetailsScreen(bill: bills[index]),
                      ),
                    ),
                  );
                });
          } else if (state is GetFilterError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No bills found'.tr()));
          }
        },
      ),
    );
  }
}
