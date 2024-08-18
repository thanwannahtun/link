import 'package:flutter/material.dart';

class WidgetUtil {
  static Widget textField(
      {TextEditingController? controller,
      void Function()? onTap,
      void Function(String)? onChanged,
      String? hintText,
      Color? fillColor,
      InputBorder border = InputBorder.none,
      bool autofocus = false}) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChanged,
      decoration: InputDecoration(
        fillColor: fillColor,
        filled: true,
        hintText: hintText,
        border: border,
      ),
    );
  }
}
