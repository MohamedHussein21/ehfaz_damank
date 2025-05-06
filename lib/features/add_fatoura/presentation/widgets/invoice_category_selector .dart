import 'package:ahfaz_damanak/features/add_fatoura/presentation/cubit/add_fatoura_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/categoris_model.dart';

class InvoiceCategorySelector extends StatefulWidget {
  final Function(int) onCategorySelected;
  final List<CategoryModel> categories;

  const InvoiceCategorySelector({
    super.key,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  _InvoiceCategorySelectorState createState() =>
      _InvoiceCategorySelectorState();
}

class _InvoiceCategorySelectorState extends State<InvoiceCategorySelector> {
  int? categoryId;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.categories.isEmpty) {
      context.read<AddFatouraCubit>().getCategoris();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return const CircularProgressIndicator();
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "select category".tr(),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedCategory,
      items: widget.categories.map((category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
          categoryId = widget.categories
              .firstWhere((category) => category.name == value)
              .id;
        });
        if (categoryId != null) widget.onCategorySelected(categoryId!);
      },
    );
  }
}
