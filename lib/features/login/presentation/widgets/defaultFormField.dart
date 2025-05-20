import 'package:ahfaz_damanak/core/utils/mediaQuery.dart';
import 'package:flutter/material.dart';

class DefaultTextForm extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType type;
  final ValueChanged? onSubmit;
  final ValueChanged? onChange;
  final GestureTapCallback? onTap;
  bool? isPassword = false;
  final String? Function(String? val)? validate;
  final String hint;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? suffixPressed;
  bool isClickable = true;
  final Iterable<String>? aoutofillHints;

  DefaultTextForm({
    super.key,
    this.controller,
    this.isPassword,
    required this.type,
    this.onSubmit,
    this.onChange,
    this.onTap,
    required this.validate,
    required this.hint,
    required this.hintStyle,
    this.prefix,
    this.suffix,
    this.suffixPressed,
    this.aoutofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.heigh * 0.07,
      child: TextFormField(
        autofillHints: aoutofillHints,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword!,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          hintText: hint,
          hintTextDirection: TextDirection.rtl,
          hintStyle: hintStyle,
          prefixIcon: prefix,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: suffix!,
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
