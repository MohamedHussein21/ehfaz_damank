import 'package:flutter/material.dart';

import '../../../../core/utils/color_mange.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final VoidCallback? submit;
  final double width;
  final Color? color;
  final bool isLoading;

  const DefaultButton({
    super.key,
    required this.title,
    required this.submit,
    required this.width,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = submit == null;
    final buttonColor = color ?? ColorManger.defaultColor;
    final disabledColor = buttonColor.withOpacity(0.5);

    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isDisabled ? disabledColor : buttonColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : submit,
          borderRadius: BorderRadius.circular(15),
          child: Center(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
