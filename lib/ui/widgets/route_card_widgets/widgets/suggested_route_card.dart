import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/extensions/util_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widgets/route_card_vertical_widget.dart';
import 'route_card_interface.dart';

class SuggestedRouteCard implements RouteCardInterface {
  @override
  Widget build(BuildContext context, RouteModel route, CategoryType category,
      {Map<String, dynamic>? arguments}) {
    double cardWidth(BuildContext context) {
      double screenWidth = context.screenWidth;

      return context.isTablet
          ? screenWidth * 0.5
          : context.isDesktop
              ? screenWidth * 0.33
              : screenWidth * 0.8;
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          margin: const EdgeInsets.all(AppInsets.inset5),
          elevation: 2.0,
          color: context.greyFilled,
          child: SizedBox(
            width: cardWidth(context),
            child: GestureDetector(
              onTap: () {
                context.pushNamed(RouteLists.routeDetailPage, arguments: route);
              },
              child: RouteCardVerticalWidget(
                route: route,
                onRoutePressed: (route) {
                  context.pushNamed(RouteLists.routeDetailPage,
                      arguments: route);
                },
                onAgencyPressed: (route) {
                  context.pushNamed(
                    RouteLists.publicAgencyProfile,
                    arguments: route.agency,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
