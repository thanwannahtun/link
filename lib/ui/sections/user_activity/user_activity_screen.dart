import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../core/utils/app_insets.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({super.key});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return CustomScaffoldBody(
      body: _body(context),
      title: Text(
        "Activity",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _body(BuildContext ctx) {
    return Builder(
      builder: (BuildContext context) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        );
      },
    );
  }
}
