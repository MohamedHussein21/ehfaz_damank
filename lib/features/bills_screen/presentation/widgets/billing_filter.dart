import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import '../cubit/bills_screen_state.dart';

class BillsFilterSheet extends StatefulWidget {
  const BillsFilterSheet({super.key});

  @override
  _BillsFilterSheetState createState() => _BillsFilterSheetState();
}

class _BillsFilterSheetState extends State<BillsFilterSheet> {
  Map<String, bool> selectedFilters = {
    "إلكترونيات": false,
    "أجهزة منزلية": false,
    "ادوات صحية": false,
    "سيارات": false,
    "ادوات كهربائية": false,
    "اخري": false,
    "التقدم أول": false,
    "الأحدث أول": false,
    "الضمان الأطول مدة": false,
    "الضمان الأقرب للانتهاء": false,
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillsScreenCubit, BillsScreenState>(
      listener: (context, state) {
        if (state is GetFilterSuccus) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("فلترة الفواتير",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("الفئة",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        "إلكترونيات",
                        "أجهزة منزلية",
                        "ادوات صحية",
                        "سيارات",
                        "ادوات كهربائية",
                        "اخري"
                      ].map(_buildFilterButton).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text("الترتيب الزمني",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ["التقدم أول", "الأحدث أول"]
                          .map(_buildFilterButton)
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text("الضمان",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ["الضمان الأطول مدة", "الضمان الأقرب للانتهاء"]
                          .map(_buildFilterButton)
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          int? categoryId;
                          String? orderBy;
                          String? damanOrder;

                          selectedFilters.forEach((key, value) {
                            if (value) {
                              if (key == "إلكترونيات") categoryId = 1;
                              if (key == "أجهزة منزلية") categoryId = 2;
                              if (key == "ادوات صحية") categoryId = 3;
                              if (key == "سيارات") categoryId = 4;
                              if (key == "ادوات كهربائية") categoryId = 5;
                              if (key == "اخري") categoryId = 6;
                              if (key == "التقدم أول") orderBy = "oldest";
                              if (key == "الأحدث أول") orderBy = "newest";
                              if (key == "الضمان الأطول مدة") {
                                damanOrder = "longest";
                              }
                              if (key == "الضمان الأقرب للانتهاء") {
                                damanOrder = "closest";
                              }
                            }
                          });

                          context.read<BillsScreenCubit>().getFilter(
                                categoryId: categoryId ?? 0,
                                orderBy: orderBy ?? '',
                                damanOrder: damanOrder ?? '',
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.defaultColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("تطبيق",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterButton(String title) {
    bool isSelected = selectedFilters[title] ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilters[title] = !isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? ColorManger.defaultColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color:
                  isSelected ? ColorManger.defaultColor : Colors.grey.shade400),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ColorManger.defaultColor.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
