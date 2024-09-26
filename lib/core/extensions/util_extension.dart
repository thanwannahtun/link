import 'package:flutter/material.dart';

extension UtilExtension on BuildContext {
  Size get size {
    return MediaQuery.of(this).size;
  }
}
