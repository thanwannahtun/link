import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/widgets/cached_image.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../domain/api_utils/api_query.dart';
import '../../../../../domain/enums/category_type.dart';
import '../../../../screens/profile/route_model_card.dart';

class TrendingRoutesScreen extends StatefulWidget {
  const TrendingRoutesScreen({super.key});

  @override
  State<TrendingRoutesScreen> createState() => _TrendingRoutesScreenState();
}

class _TrendingRoutesScreenState extends State<TrendingRoutesScreen> {
  List<RouteModel> routes = [];
  late PostRouteCubit _trendingRouteCubit;

  @override
  void initState() {
    _trendingRouteCubit = PostRouteCubit()
      ..getRoutesByCategory(
          query: APIQuery(categoryType: CategoryType.trendingRoutes, limit: 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
        backButton: BackButton(
          onPressed: () => context.pop(),
        ),
        body: _body(context),
        title: const Text("Trending Routes"));
  }

  Widget _body(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        _trendingRouteCubit.getRoutesByCategory(
            query:
                APIQuery(categoryType: CategoryType.trendingRoutes, limit: 5));
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            // Appears immediately when user scrolls up
            snap: true,
            // Snaps into position when scrolled up
            pinned: false,
            // SliverAppBar is not pinned at the top
            expandedHeight: 100.0,
            // Height of the app bar when expanded

            automaticallyImplyLeading: false,
            // Removes back button
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground, // Smooth zoom effect on scroll
                StretchMode.fadeTitle, // Title fades on collapse
              ],
              titlePadding: const EdgeInsets.all(16), // Custom title padding
              centerTitle: true,
              title: Row(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                  ).expanded(),
                  SizedBox(
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.compare_arrows_sharp)),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                  ).expanded(),
                ],
              ),
            ),
          ),
          BlocBuilder<PostRouteCubit, PostRouteState>(
            bloc: _trendingRouteCubit,
            builder: (BuildContext context, PostRouteState state) {
              if (state.status == BlocStatus.fetched) {
                routes = state.routeModels;
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    RouteModel route = routes[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: _routeCardTemp(route),
                      child: RouteModelCard(
                        route: route,
                        onPhonePressed: (route) {},
                        onRemove: (route) {},
                        onRoutePressed: (route) {
                          print(
                              "--> go route Detail Screen ${route.origin?.name} ");
                        },
                      ),
                      // child: RouteCard(route: route, controller: _controller),
                    );
                  }, childCount: routes.length),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.white10,
                        highlightColor: Colors.white38,
                        child: Container(
                          height: 50,
                          color: Colors.amberAccent,
                        ),
                      ),
                    );
                  }, childCount: 15),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

/// End Old Widget
///

typedef VoidCallback = void Function();

class RouteCardController {
  final List<VoidCallback> _addCallbacks = [];
  final List<VoidCallback> _removeCallbacks = [];

  // Adds a new route via the specified callback.
  void addItem(VoidCallback addCallback) {
    _addCallbacks.add(addCallback);
    _executeAddCallbacks();
  }

  // Removes a route via the specified callback.
  void removeItem(VoidCallback removeCallback) {
    _removeCallbacks.add(removeCallback);
    _executeRemoveCallbacks();
  }

  // Executes all add callbacks.
  void _executeAddCallbacks() {
    for (var callback in _addCallbacks) {
      callback();
    }
  }

  // Executes all remove callbacks.
  void _executeRemoveCallbacks() {
    for (var callback in _removeCallbacks) {
      callback();
    }
  }

  // Clears all callbacks.
  void clearCallbacks() {
    _addCallbacks.clear();
    _removeCallbacks.clear();
  }
}

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final RouteCardController controller;

  const RouteCard({Key? key, required this.route, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route Post',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8.0),
            Text('From: ${route.origin?.name ?? 'Unknown'}'),
            Text('To: ${route.destination?.name ?? 'Unknown'}'),
            const SizedBox(height: 8.0),
            Text(
                'Schedule Date: ${route.scheduleDate?.toLocal().toString() ?? 'N/A'}'),
            Text(
                'Price per Traveller: \$${route.pricePerTraveller?.toString() ?? 'N/A'}'),
            const SizedBox(height: 8.0),
            Text(route.description ?? 'No description available'),
            const SizedBox(height: 8.0),
            if (route.image != null)
              SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: CachedImage(imageUrl: route.image ?? "")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    controller.removeItem(() {
                      print("Route removed: ${route.id}");
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
