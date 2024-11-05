import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post/upload_new_post_page.dart';
import 'package:link/ui/screens/profile/route_model_card.dart';
import 'package:link/ui/sections/upload/route_array_upload/routemodel/routemodel.dart';
import 'package:link/ui/widget_extension.dart';

import '../../core/widgets/cached_image.dart';
import '../sections/hot_and_trending/hot_and_trending_screen.dart';
import '../utils/expandable_text.dart';

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
                              RouteCardDetailScreen(route: heroRoute),
                        ));
                      },
                      child: RouteSummaryWidget(
                        route: heroRoute,
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
                        origin: heroRoute.origin?.name ?? "",
                        destination: heroRoute.destination?.name ?? "",
                        scheduleDate: heroRoute.scheduleDate ?? DateTime.now(),
                        price: heroRoute.pricePerTraveller ?? 0.0,
                        imageUrl: heroRoute.image,
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

class RouteSummaryWidget extends StatefulWidget {
  final Routemodel route;

  const RouteSummaryWidget({
    super.key,
    required this.route,
  });

  @override
  _RouteSummaryWidgetState createState() => _RouteSummaryWidgetState();
}

class _RouteSummaryWidgetState extends State<RouteSummaryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RouteHeader(route: Routemodel()),
          if (widget.route.image != null)
            SizedBox(
                height: 180,
                width: double.infinity,
                child: CachedImage(imageUrl: widget.route.image ?? "")),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Route - ${widget.route.origin?.name ?? ""} To ${widget.route.destination?.name ?? ""} ")
                    .styled(fw: FontWeight.bold),
                // Text("From: ${widget.route.origin}").styled(fw: FontWeight.bold),
                // Text("To: ${widget.route.destination}").styled(fw: FontWeight.bold),
                Text("Date - ${DateTimeUtil.formatDateTime(widget.route.scheduleDate)}")
                    .styled(fw: FontWeight.bold),
                Text("Price - \$${widget.route.pricePerTraveller?.toStringAsFixed(2)}")
                    .styled(fw: FontWeight.bold),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("View Midpoints",
                          style: TextStyle(color: Colors.blue)),
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.blue),
                    ],
                  ),
                ),
                if (_isExpanded)
                  Column(
                    children: widget.route.midpoints!
                        .map((midpoint) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.location_on),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(midpoint.city?.name ??
                                                "Unknown City")
                                            .styled(fw: FontWeight.bold),
                                        Text(midpoint.price.toString()).styled(
                                            fw: FontWeight.bold,
                                            color: context.greyColor),
                                      ],
                                    ),
                                    ExpandableText(
                                        text: midpoint.description ??
                                            "No description")
                                  ],
                                ).expanded()
                              ],
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
          RouteFooter(route: Routemodel()),
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
            RouteHeader(route: Routemodel()),
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

class RouteCardWidget extends StatelessWidget {
  final String origin;
  final String destination;
  final DateTime scheduleDate;
  final double price;
  final String? imageUrl;

  const RouteCardWidget({
    super.key,
    required this.origin,
    required this.destination,
    required this.scheduleDate,
    required this.price,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RouteHeader(route: Routemodel()),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("From: $origin",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("To: $destination",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "Date: ${scheduleDate.toIso8601String().substring(0, 10)}"),
                      Text("Price: \$${price.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
                // if (imageUrl != null)
                Expanded(child: CachedImage(imageUrl: imageUrl ?? "")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RouteCardDetailScreen extends StatefulWidget {
  const RouteCardDetailScreen({super.key, required this.route});

  final Routemodel route;

  @override
  State<RouteCardDetailScreen> createState() => _RouteCardDetailScreenState();
}

class _RouteCardDetailScreenState extends State<RouteCardDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: RouteSummaryWidget(route: widget.route))),
          Container(height: 50, color: Colors.amber),
        ],
      ),
    );
  }
}
