import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/sections/hero_home/widgets/route_list_builder.dart';

class TrendingAndHotRoutesList extends StatelessWidget {
  const TrendingAndHotRoutesList({super.key});

  @override
  Widget build(BuildContext context) {
    return RoutesListBuilder(
      key: const Key("trending-and-hot-route-list-key"),
      categoryType: CategoryType.trendingRoutes,
      fetchRoutes: (query) async {
        context.read<PostRouteCubit>().getRoutesByCategory(query: query);
      },
    );
  }
}
