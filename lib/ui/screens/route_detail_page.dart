import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/styles/app_theme.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/screens/profile/route_model_card.dart';
import 'package:link/ui/sections/upload/route_array_upload/routemodel/routemodel.dart';
import 'package:link/ui/widget_extension.dart';

import '../../core/widgets/cached_image.dart';
import '../../domain/api_utils/api_query.dart';
import '../utils/expandable_text.dart';
import 'package:collection/collection.dart';

/*
class RouteDetailPage extends StatefulWidget {
  const RouteDetailPage({super.key});

  @override
  State<RouteDetailPage> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  Post? post;
  late PostRouteCubit _postRouteCubit;
  List<Routemodel> _routeModels = [];
  List<Post> posts = [];
  bool _initial = true;

  @override
  void initState() {
    super.initState();
    _postRouteCubit = PostRouteCubit();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final route = ModalRoute.of(context)?.settings.arguments as Routemodel?;
        if (route != null) {
          print("route json ::: ${route.toJson()}");
          _postRouteCubit.getPostWithRoutes(query: {
            "categoryType": "post_with_routes",
            "limit": 10,
            // "post_id": route.post
          });
        }
        // post = ModalRoute.of(context)?.settings.arguments as Post;
      }
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Container(),
        // leadingWidth: 0,
        title: RouteHeader(
            route: post == null
                ? Routemodel()
                : post?.routes?.first ?? Routemodel()),
      ),
      body: BlocConsumer<PostRouteCubit, PostRouteState>(
        bloc: _postRouteCubit,
        builder: (context, state) {
          if (state.status == BlocStatus.fetched) {
            post = state.routes.last;
            posts = state.routes;
            _routeModels = post?.routes ?? [];
            print("post json :::: ${post?.toJson()}");
            final heroRoute = _routeModels.last;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RouteInfo(route: heroRoute),
                        Column(
                          children: heroRoute.midpoints!
                              .map((mp) => MidpointItem(midpoint: mp))
                              .toList(),
                        ),
                        ExpandableText(
                          text: heroRoute.description ?? "",
                          textStyle: TextStyle(color: context.greyColor),
                          maxLines: 2,
                        ),
                        if (heroRoute.image != null)
                          SizedBox(
                              width: double.infinity,
                              height: 120,
                              child:
                                  CachedImage(imageUrl: heroRoute.image ?? "")),
                        const SizedBox(height: 5),
                        // RouteMidpoints(midpoints: _routeModels[0].midpoints ?? [])
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor.withOpacity(0.3),
                    height: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("More from Agency:"),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.keyboard_arrow_right))
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: HorizontalPostWithRoutesWidget(posts: posts),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 200,
                    color: Colors.amberAccent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RouteCardDetailScreen(routeParam: heroRoute),
                        ));
                      },
                      child: RouteInfoCardWidget(
                        route: heroRoute,
                        onAgencyPressed: (route) {},
                        onRoutePressed: (route) {},
                      ),
                    ),
                  ),
                  SizedBox(height: 1),
                  Container(
                    color: Colors.amber,
                    child: RouteTimelineWidget(
                        origin: heroRoute.origin?.name ?? "",
                        destination: heroRoute.destination?.name ?? "",
                        scheduleDate: heroRoute.scheduleDate ?? DateTime.now(),
                        price: heroRoute.pricePerTraveller ?? 0.0,
                        midpoints: heroRoute.midpoints ?? []),
                  ),
                  SizedBox(height: 1),
                  Container(
                      color: Colors.amber,
                      child: RouteCardWidget(
                        route: heroRoute,
                      )),
                  SizedBox(height: 1),
                  Container(
                    color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RouteModelCard(route: heroRoute),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
*/
typedef RouteCallback = void Function(RouteModel route);

class RouteInfoCardWidget extends StatefulWidget {
  final RouteModel route;
  final RouteCallback onRoutePressed;
  final RouteCallback onAgencyPressed;

  const RouteInfoCardWidget({
    super.key,
    required this.route,
    required this.onRoutePressed,
    required this.onAgencyPressed,
  });

  @override
  State<RouteInfoCardWidget> createState() => _RouteInfoCardWidgetState();
}

class _RouteInfoCardWidgetState extends State<RouteInfoCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1))),
      margin: const EdgeInsets.all(0.0),
      child: InkWell(
        onTap: () => widget.onRoutePressed.call(widget.route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RouteHeader(
              route: widget.route,
              onAgencyPressed: (route) => widget.onAgencyPressed.call(route),
            ),
            if (widget.route.image != null)
              SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CachedImage(imageUrl: widget.route.image ?? "")),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RouteInfoBodyWithMidpoints(route: widget.route),
            ),
            RouteFooter(
              route: widget.route,
              onBookPressed: (RouteModel route) =>
                  widget.onRoutePressed.call(route),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteInfoBodyWithMidpoints extends StatelessWidget {
  const RouteInfoBodyWithMidpoints({
    super.key,
    required this.route,
    this.cardWidth,
  });

  final RouteModel route;
  final double? cardWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth ?? double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Route  - ${route.origin?.name ?? ""} To ${route.destination?.name ?? ""} ")
              .styled(fw: FontWeight.bold),
          Text("Date   - ${DateTimeUtil.formatDateTime(route.scheduleDate)}")
              .styled(fw: FontWeight.bold),
          Text("Price   - \$${route.pricePerTraveller?.toStringAsFixed(2)}")
              .styled(fw: FontWeight.bold),
          if ((route.midpoints ?? []).isNotEmpty)
            Text(
              route.midpoints!
                  .map((m) => m.city?.name)
                  .where((name) => name != null)
                  .join(' - '),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: context.greyColor),
            ).fittedBox()
        ],
      ),
    );
  }
}

class RouteTimelineWidget extends StatelessWidget {
  final String origin;
  final String destination;
  final DateTime scheduleDate;
  final double price;
  final List<RouteMidpoint> midpoints;

  const RouteTimelineWidget({
    super.key,
    required this.origin,
    required this.destination,
    required this.scheduleDate,
    required this.price,
    required this.midpoints,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            RouteHeader(route: RouteModel()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Route Timeline",
                    style: Theme.of(context).textTheme.headlineLarge),
                Text("Origin: $origin"),
                for (var i = 0; i < midpoints.length; i++)
                  ListTile(
                    leading: Icon(Icons.location_pin),
                    title: Text(midpoints[i].city?.name ?? "Unknown City"),
                    subtitle: Text("Stop ${i + 1}"),
                  ),
                Text("Destination: $destination"),
                SizedBox(height: 8),
                Text(
                    "Scheduled Date: ${scheduleDate.toIso8601String().substring(0, 10)}"),
                Text("Price: \$${price.toStringAsFixed(2)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RouteDetailPage extends StatelessWidget {
  final RouteModel route;

  const RouteDetailPage({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RouteHeader(route: route),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From: ${route.origin?.name ?? "Origin"}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("To: ${route.destination?.name ?? "Destination"}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "Date: ${DateTimeUtil.formatDateTime(route.scheduleDate)}"),
                      Text(
                          "Price: \$${(route.pricePerTraveller ?? 0).toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                // if (imageUrl != null)
                Expanded(child: CachedImage(imageUrl: route.image ?? "")),
              ],
            ),
          ).expanded(),
        ],
      ),
    );
  }
}

class RouteDetailScreen extends StatefulWidget {
  const RouteDetailScreen({super.key});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  Post? post;
  late PostRouteCubit _postRouteCubit;
  List<RouteModel> _routes = [];

  // List<Post> posts = [];
  bool _initial = true;

  String? routeId;

  @override
  void initState() {
    super.initState();
    _postRouteCubit = PostRouteCubit();
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final route = ModalRoute.of(context)?.settings.arguments as RouteModel?;
        if (route != null) {
          routeId = route.id;
          print("route json ::: ${route.toJson()}");
          _postRouteCubit.getPostWithRoutes(
              query: APIQuery(categoryType: "post_with_routes", limit: 5));
        }
      }
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("routeId ::: ${routeId}");
    return Scaffold(
      // backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: RouteHeader(route: RouteModel()),
      ),
      body: BlocConsumer<PostRouteCubit, PostRouteState>(
        bloc: _postRouteCubit,
        listener: (BuildContext context, PostRouteState state) {},
        builder: (BuildContext context, PostRouteState state) {
          if (state.status == BlocStatus.fetched) {
            // final route = state.routes.first.routes?.firstOrNull;
            // _routes = state.routeModels;
            _routes = state.routes.first.routes!;
            print("_routes length ::: ${_routes.length}");
            final route = _routes.firstWhereOrNull(
              (r) => r.id == routeId,
            );

            print("route Hero match ::: ${route?.toJson()}");

            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: _routeDetailWidget(
                            route: route ?? const RouteModel()))),
                Container(
                  height: 50,
                  color: Theme.of(context).cardColor,
                  child: RouteFooter(
                    route: route ?? const RouteModel(),
                    onBookPressed: (route) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }

  Widget _routeDetailWidget({required RouteModel route}) {
    final suggestedRoutes = _routes.where((r) => r.id != routeId).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (route.image != null)
          SizedBox(
              height: 180,
              width: double.infinity,
              child: CachedImage(imageUrl: route.image ?? "")),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              padding: const EdgeInsets.all(AppInsets.inset10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(
                    bottom: BorderSide(color: Colors.blue, width: 3)),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: RouteInfoBodyWithMidpoints(route: route)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: ExpandableText(
            text: route.description ?? "",
            maxLines: 8,
            textStyle: TextStyle(color: context.greyColor),
          ),
        ),
        if ((route.midpoints ?? []).isNotEmpty) _midpointsBuilder(route),
        _moreRoutesFromAgency(route, suggestedRoutes),
      ],
    );
  }

  Card _midpointsBuilder(RouteModel route) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Midpoints").styled(
                    fw: FontWeight.bold,
                    fs: AppInsets.font20,
                    color: context.greyColor),
                Text("${(route.midpoints ?? []).length} stops")
                    .styled(fw: FontWeight.bold, color: context.greyColor),
              ],
            ),
          ),
          Card.filled(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  RouteMidpointDetailWidget(midpoints: route.midpoints ?? []),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _moreRoutesFromAgency(
      RouteModel route, List<RouteModel> suggestedRoutes) {
    return SizedBox(
      width: double.infinity,
      child: Card.filled(
        margin: const EdgeInsets.all(0.0),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            suggestedRoutes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "More from ${route.agency?.name ?? "Agency"}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: context.greyColor),
                    ),
                  )
                : Container(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: suggestedRoutes
                      .map((r) => Card.filled(
                            semanticContainer: true,
                            color: context.greyFilled,
                            margin: const EdgeInsets.all(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RouteInfoBodyWithMidpoints(
                                route: r,
                                cardWidth:
                                    MediaQuery.of(context).size.width - 64,
                              ),
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteMidpointDetailWidget extends StatelessWidget {
  const RouteMidpointDetailWidget({super.key, required this.midpoints});

  final List<RouteMidpoint> midpoints;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: midpoints.map((m) => _midpointRow(context, m)).toList());
  }

  Widget _midpointRow(BuildContext context, RouteMidpoint m) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(
        Icons.garage,
        color: context.successColor,
        size: 20,
      ),
      const SizedBox(width: AppInsets.inset5),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(m.city?.name ?? "Unknown City").styled(fw: FontWeight.bold),
              Text(m.price.toString()).styled(fw: FontWeight.bold),
            ],
          ),
          ExpandableText(
            text: (m.description ?? "No description"),
            textStyle: TextStyle(color: context.greyColor),
          ).padding(padding: const EdgeInsets.only(top: AppInsets.inset5))
        ],
      ).expanded(),
    ]).padding(padding: const EdgeInsets.only(bottom: AppInsets.inset15));
  }
}
