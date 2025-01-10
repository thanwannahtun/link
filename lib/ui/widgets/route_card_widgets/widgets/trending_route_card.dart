import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/extensions/util_extension.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/screens/route_detail_page.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/route_list.dart';

import 'route_card_interface.dart';

class TrendingRouteCard implements RouteCardInterface {
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

    return SizedBox(
        width: cardWidth(context),
        child: GestureDetector(
          onTap: () {
            context.pushNamed(RouteLists.routeDetailPage, arguments: route);
          },
          child: RouteDetailPage(
            route: route,
          ),
        ));

    ///
  }
}
