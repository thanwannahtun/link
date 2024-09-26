import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

class TrendingRouteCardDetail extends StatefulWidget {
  const TrendingRouteCardDetail({super.key});

  @override
  State<TrendingRouteCardDetail> createState() =>
      _TrendingRouteCardDetailState();
}

class _TrendingRouteCardDetailState extends State<TrendingRouteCardDetail> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: Container(),
      title: "Card Detail",
      backButton: BackButton(
        color: context.onPrimaryColor,
        onPressed: () => context.pop(),
      ),
    );
  }
}
