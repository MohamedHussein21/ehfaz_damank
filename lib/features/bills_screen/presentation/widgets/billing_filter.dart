import 'package:ahfaz_damanak/features/add_fatoura/data/models/categoris_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahfaz_damanak/core/utils/color_mange.dart';
import 'package:ahfaz_damanak/features/bills_screen/presentation/cubit/bills_screen_cubit.dart';
import '../../../add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
import '../cubit/bills_screen_state.dart';

class BillsFilterSheet extends StatefulWidget {
  const BillsFilterSheet({super.key, required this.cubit});
  final BillsScreenCubit cubit;
  @override
  _BillsFilterSheetState createState() => _BillsFilterSheetState();
}

class _BillsFilterSheetState extends State<BillsFilterSheet> {
  Map<String, bool> selectedFilters = {
    "oldest".tr(): false,
    "newest".tr(): false,
    "longest Warranty".tr(): false,
    "shortest Warranty".tr(): false,
  };

  String? order;
  List<CategoryModel> selectedCategories = <CategoryModel>[];
  String? warranty;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BillsScreenCubit, BillsScreenState>(
      listener: (context, state) {},
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
                        Text("Filter Bills".tr(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text("Category".tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    BlocProvider(
                      create: (context) => AddFatouraCubit()..getCategoris(),
                      child: BlocBuilder<AddFatouraCubit, AddFatouraState>(
                        builder: (context, state) {
                          var cubit = AddFatouraCubit.get(context);
                          var categories = cubit.categoryModel ?? [];
                          // for (var category in categories) {
                          //   selectedFilters.putIfAbsent(
                          //       category.name, () => false);
                          // }
                          if (categories.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: categories
                                .map((category) => _buildFilterButton(
                                    name: category.name,
                                    onpress: () {
                                      if (selectedCategories
                                          .where(
                                              (item) => item.id == category.id)
                                          .isEmpty) {
                                        setState(() {
                                          selectedCategories.add(category);
                                        });
                                      } else {
                                        setState(() {
                                          selectedCategories.remove(category);
                                        });
                                      }
                                    },
                                    isSelected: selectedCategories
                                        .where((item) => item.id == category.id)
                                        .isNotEmpty))
                                .toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("Sort by time".tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, children: [
                      _buildFilterButton(
                          name: "oldest".tr(),
                          onpress: () {
                            setState(() {
                              order = "oldest";
                            });
                          },
                          isSelected: order == 'oldest'),
                      _buildFilterButton(
                          name: "newest".tr(),
                          onpress: () {
                            setState(() {
                              order = "newest";
                            });
                          },
                          isSelected: order == 'newest'),
                    ]),
                    const SizedBox(height: 24),
                    Text("warranty".tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(spacing: 10, children: [
                      _buildFilterButton(
                          name: "longest Warranty".tr(),
                          onpress: () {
                            setState(() {
                              warranty = "longest";
                            });
                          },
                          isSelected: warranty == 'longest'),
                      _buildFilterButton(
                          name: "shortest Warranty".tr(),
                          onpress: () {
                            setState(() {
                              warranty = "shortest";
                            });
                          },
                          isSelected: warranty == 'shortest')
                    ]),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // int? categoryId;
                          // String? orderBy;
                          // String? damanOrder;

                          // selectedFilters.forEach((key, value) {
                          //   if (value) {
                          //     if (key == "oldest") orderBy = "oldest";
                          //     if (key == "newest") orderBy = "newest";
                          //     if (key == "longest") damanOrder = "longest";
                          //     if (key == "shortest") damanOrder = "closest";
                          //   }
                          // });

                          // final categories =
                          //     AddFatouraCubit.get(context).categoryModel ?? [];
                          // for (var category in categories) {
                          //   if (selectedFilters[category.name] == true) {
                          //     categoryId = category.id;
                          //     break;
                          //   }
                          // }

                          widget.cubit.getFilter(
                            categoryId: selectedCategories.last.id,
                            orderBy: order,
                            damanOrder: warranty,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManger.defaultColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("confirm".tr(),
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterButton(
      {required String name,
      required Function() onpress,
      required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          onpress();
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
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
