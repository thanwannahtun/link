import 'package:flutter/material.dart';
import 'package:link/core/extensions/util_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class RouteFetchingWidget extends StatelessWidget {
  const RouteFetchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: context.primaryColor,
        highlightColor: context.onPrimaryColor,
        child: Card.filled(
          elevation: 0.5,
          color: context.secondaryColor,
          child: LayoutBuilder(builder: (context, constraints) {
            double screenWidth = context.screenWidth;

            double cardWidth = context.isTablet
                ? screenWidth * 0.5
                : context.isDesktop
                    ? screenWidth * 0.33
                    : screenWidth * 0.8;

            return SizedBox(width: cardWidth);
          }),
        ),
      ),
      itemCount: 7,
    );
  }
}
