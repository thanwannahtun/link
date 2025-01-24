import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class ShowRoutesByCategoryFetchMoreShimmerWidget extends StatelessWidget {
  /// [shimmer] while loading or fetching more data. [ infinite list ]
  const ShowRoutesByCategoryFetchMoreShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.greyColor,
      highlightColor: context.greyFilled,
      child: const SizedBox(
        width: double.infinity,
        height: 250,
        child: Card(),
      ),
    );
  }
}
