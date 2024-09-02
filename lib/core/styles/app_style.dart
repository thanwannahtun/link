import 'package:flutter/material.dart';
import 'package:link/core/styles/app_colors.dart';

class AppStyle {
  static const ButtonStyle buttonLight = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.white),
      foregroundColor: WidgetStatePropertyAll(AppColors.green));
  static const ButtonStyle buttonDark = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(AppColors.green),
      foregroundColor: WidgetStatePropertyAll(AppColors.white));
}
