import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widget_extension.dart';

class AgencyInfoActionBar extends StatelessWidget {
  const AgencyInfoActionBar({super.key});

  Widget _buildMobileActionBar(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: context.scaffoldBackgroundColor,
      child: StatefulBuilder(
        builder: (context, rebuild) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _actionButton(context, Icons.add, "Follow"),
                _actionButton(context, Icons.phone, "Call"),
              ],
            ).expanded(),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _actionButton(context, Icons.add_location_rounded, "Map"),
                _actionButton(context, Icons.workspace_premium, "Verified"),
              ],
            ).expanded()
          ],
        ),
      ),
    ));
  }

  Widget _buildDesktopActionBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        color: context.scaffoldBackgroundColor,
        height: 45,
        child: StatefulBuilder(
          builder: (context, rebuild) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _actionButton(context, Icons.add, "Follow").expanded(),
              _actionButton(context, Icons.phone, "Call").expanded(),
              _actionButton(context, Icons.add_location_rounded, "Map")
                  .expanded(),
              _actionButton(context, Icons.workspace_premium, "Verified")
                  .expanded(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool widerScreen = MediaQuery.of(context).size.width > 600;
    return widerScreen
        ? _buildDesktopActionBar(context)
        : _buildMobileActionBar(context);
  }

  Widget _actionButton(BuildContext context, IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        onPressed: () {},
        label: Text(label),
      ),
    );
  }
}

// // Pinned Header Delegate
// class _PinnedHeader extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   final double maxExtentValue;
//
//   _PinnedHeader({required this.child, required this.maxExtentValue});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return child;
//   }
//
//   @override
//   double get maxExtent => maxExtentValue;
//
//   @override
//   double get minExtent => maxExtentValue;
//
//   @override
//   bool shouldRebuild(covariant _PinnedHeader oldDelegate) {
//     return oldDelegate.child != child;
//   }
// }
