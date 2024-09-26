import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

class TrendingRoutesCard extends StatefulWidget {
  const TrendingRoutesCard({super.key});

  @override
  State<TrendingRoutesCard> createState() => _TrendingRoutesCardState();
}

class _TrendingRoutesCardState extends State<TrendingRoutesCard> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: Container(),
      title: "Trending Routes",
      // backButton: BackButton(
      //   onPressed: () => context.pop(),
      // ),
      action: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt,
            size: AppInsets.inset30,
            color: context.onPrimaryColor,
          )),
    );
  }
}
