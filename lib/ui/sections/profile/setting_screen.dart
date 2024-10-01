import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';

import '../../../core/utils/app_insets.dart';
import '../../widgets/custom_scaffold_body.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: Container(),
      title: Text("Settings",
          style: TextStyle(
              color: context.onPrimaryColor,
              fontSize: AppInsets.font25,
              fontWeight: FontWeight.bold)),
    );
  }
}
