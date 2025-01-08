import 'package:flutter/material.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/widgets/route_card_widgets/route_card_widgets.dart';

import 'route_card_interface.dart';

class RouteCardWidget extends StatelessWidget {
  /// Render corresponding [RouteCardWidget] based on the [CategoryType] provided
  ///
  /// [SponsoredRouteCard] , [SuggestedRouteCard] ,
  ///
  /// [TrendingRouteCard] , [PostWithRoutesCard]
  ///
  /// Optional [arguments] for [Data] passing down
  const RouteCardWidget(
      {super.key,
      required this.route,
      required this.categoryType,
      this.arguments});

  final RouteModel route;
  final CategoryType categoryType;
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context) {
    final RouteCardInterface routeCard =
        _RouteCardFactory.getRouteCard(categoryType, arguments);
    return routeCard.build(context, route, categoryType, arguments: arguments);
  }
}

class _RouteCardFactory {
  ///
  ///```dart
  ///     final RouteCardInterface routeCard = _RouteCardFactory.getRouteCard(categoryType, arguments);
  ///     return routeCard.build(context, route, categoryType, arguments: arguments);
  ///```
  static RouteCardInterface getRouteCard(
      CategoryType categoryType, Map<String, dynamic>? extraArgs) {
    switch (categoryType) {
      case CategoryType.trendingRoutes:
        return TrendingRouteCard();
      case CategoryType.sponsoredRoutes:
        return SponsoredRouteCard();
      case CategoryType.suggestedRoutes:
        return SuggestedRouteCard();
      case CategoryType.searchedRoutes:
        return SuggestedRouteCard();
      case CategoryType.postWithRoutes:
        return PostWithRoutesCard();
      default:
        throw UnimplementedError('CategoryType $categoryType not implemented');
    }
  }
}
