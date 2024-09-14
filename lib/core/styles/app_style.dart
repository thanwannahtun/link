import 'package:flutter/material.dart';
import 'package:link/core/styles/app_colors.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';

class AppStyle {
  static const ButtonStyle buttonLight = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.white),
      foregroundColor: WidgetStatePropertyAll(AppColors.green));
  static ButtonStyle buttonDark(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(context.primaryColor),
      foregroundColor: WidgetStatePropertyAll(context.onPrimaryColor),
    );
  }

  static ButtonStyle buttonExpanded(BuildContext context) {
    return ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(context.secondaryColor),
        foregroundColor: WidgetStatePropertyAll(context.onPrimaryColor),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 40)));
  }

  static InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
        fillColor: context.secondaryColor,
        filled: true,
        labelStyle: TextStyle(color: context.onPrimaryColor),
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(AppInsets.inset5))));
  }
}
