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
      foregroundColor: const WidgetStatePropertyAll(AppColors.white),
    );
  }

  static InputDecoration inputDecoration = const InputDecoration(
      fillColor: Color.fromRGBO(255, 255, 255, 0.702),
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(AppInsets.inset5))));
}
