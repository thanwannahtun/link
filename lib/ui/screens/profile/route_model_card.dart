import 'package:flutter/material.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/models/app.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/buttons/book_button.dart';

import '../../../core/utils/date_time_util.dart';
import '../../../core/widgets/cached_image.dart';
import '../../utils/expandable_text.dart';
import '../../widgets/buttons/like_icon.dart';

typedef RouteCallback = void Function(RouteModel route);

/// Displays a card for a [Route] item with options to handle add/remove.
class RouteModelCard extends StatelessWidget {
  final RouteModel route;
  final RouteCallback? onPhonePressed;
  final RouteCallback? onRemove;
  final RouteCallback? onRoutePressed;
  final bool displayHeader;
  final bool displayFooter;
  final Color? cardColor;
  final Radius? borderRadius;

  const RouteModelCard({
    super.key,
    required this.route,
    this.onPhonePressed,
    this.onRemove,
    this.onRoutePressed,
    this.displayHeader = true,
    this.displayFooter = true,
    this.cardColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: cardColor ?? Theme.of(context).cardColor,
      margin: const EdgeInsets.all(0.0),
      shape: BeveledRectangleBorder(
          borderRadius:
              BorderRadius.all(borderRadius ?? const Radius.circular(1))),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () => onRoutePressed?.call(route),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayHeader ? RouteHeader(route: route) : Container(),
              RouteInfo(route: route),
              const SizedBox(height: 8),
              if (route.image != null)
                SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: CachedImage(imageUrl: route.image ?? "")),
              const SizedBox(height: 5),
              displayFooter
                  ? RouteFooter(
                      route: route,
                      onBookPressed: (RouteModel route) {},
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class RouteHeader extends StatelessWidget {
  const RouteHeader({super.key, required this.route, this.onAgencyPressed});

  final RouteModel route;
  final RouteCallback? onAgencyPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () => onAgencyPressed?.call(route),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 25,
                        height: 25,
                        child: CachedImage(
                                imageUrl: route.agency?.profileImage ?? "")
                            .clipRRect(
                                borderRadius: BorderRadius.circular(50))),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () => onAgencyPressed?.call(route),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    route.agency?.name ?? "Agency Name",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Icon(Icons.star_rate_rounded,
                      color: Colors.amber, size: 10)
                ],
              ),
            )
          ],
        ),
        IconButton(
            onPressed: () {
              print("clicked more button!");
            },
            icon: const Icon(Icons.more_vert_rounded)),
      ],
    );
  }
}

/// Widget to display the header section of the RouteModel card
class RouteInfo extends StatelessWidget {
  final RouteModel route;

  const RouteInfo({
    super.key,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${route.origin?.name ?? ""} - ${route.destination?.name ?? ""}")
            .styled(fw: FontWeight.bold, fs: 15),
        Text(
          DateTimeUtil.formatDateTime(route.scheduleDate),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          route.pricePerTraveller != null
              ? "\$${route.pricePerTraveller!.toStringAsFixed(2)}"
              : "No Price",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 5),
        (route.midpoints ?? []).isEmpty
            ? Container()
            : RouteMidpoints(midpoints: route.midpoints ?? []),
        ExpandableText(
          text: route.description ?? "",
          // textStyle: TextStyle(color: context.greyColor),
          maxLines: 2,
        ),
      ],
    );
  }
}

class RouteMidpoints extends StatelessWidget {
  final List<RouteMidpoint> midpoints;

  /// Widget to display the midpoints of the route

  const RouteMidpoints({
    super.key,
    required this.midpoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          midpoints
              .map((m) => m.city?.name)
              .where((name) => name != null)
              .join(' - '),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )
        // Column(
        //   children: midpoints.map((mp) => _MidpointItem(midpoint: mp)).toList(),
        // ),
      ],
    );
  }
}

/// Widget to display individual midpoint details
class MidpointItem extends StatelessWidget {
  final RouteMidpoint midpoint;

  const MidpointItem({
    Key? key,
    required this.midpoint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          midpoint.city?.name ?? "Unknown City",
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          midpoint.price != null
              ? "\$${midpoint.price!.toStringAsFixed(2)}"
              : "-",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}

/// Widget to display footer with action buttons
class RouteFooter extends StatelessWidget {
  final RouteModel route;
  final RouteCallback onBookPressed;

  const RouteFooter({
    super.key,
    required this.route,
    required this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                LikeIcon(
                  toggleLike: (isLiked) {},
                ),
                Text(
                  "1k +",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.comment_rounded,
                      color: context.successColor, size: 20),
                  onPressed: () {},
                ),
                Text(
                  "25 reviews",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ],
        ),
        BookButton(
          onPressed: () => onBookPressed.call(route),
          middleWare: () {
            return App.user.isAuthenticated();
          },
          onMiddleWareFailed: () =>
              context.pushNamed(RouteLists.signInWithEmail),
        ),
      ],
    );
  }
}

/// RouteModelCard
/*


class _RouteFooter extends StatelessWidget {
  final Routemodel route;
  final RouteCallback? onAdd;
  final RouteCallback? onRemove;

  const _RouteFooter({
    Key? key,
    required this.route,
    this.onAdd,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onAdd != null)
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.green),
            onPressed: () => onAdd?.call(route),
          ),
        if (onRemove != null)
          IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () => onRemove?.call(route),
          ),
      ],
    );
  }
}

 */
