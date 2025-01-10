import 'package:flutter/material.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/ui/widget_extension.dart';

import '../../core/utils/app_insets.dart';
import '../../core/utils/date_time_util.dart';
import '../../core/widgets/cached_image.dart';
import '../sections/upload/route_array_upload/route_model/route_model.dart';

typedef RouteCallback = void Function(RouteModel route);

class RouteCardVerticalWidget extends StatefulWidget {
  @override
  State<RouteCardVerticalWidget> createState() =>
      _RouteCardVerticalWidgetState();

  final RouteModel route;
  final RouteCallback onRoutePressed;
  final RouteCallback onAgencyPressed;

  const RouteCardVerticalWidget({
    super.key,
    required this.route,
    required this.onRoutePressed,
    required this.onAgencyPressed,
  });
}

class _RouteCardVerticalWidgetState extends State<RouteCardVerticalWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _sponsorHeader(widget.route),
        ),
        Expanded(
          flex: 5,
          child: _sponsorBody(widget.route, context),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _sponsorHeader(RouteModel route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (route.isSponsored ?? false)
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    "sponsored",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              Text(
                "${(route.pricePerTraveller ?? 38000).toString()} Ks",
                style: Theme.of(context).textTheme.headlineSmall,
              ).expanded(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                // borderRadius: BorderRadius.circular(50),
                onTap: () => widget.onAgencyPressed.call(route),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child:
                        CachedImage(imageUrl: route.agency?.profileImage ?? "")
                            .clipRRect(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: AppInsets.inset8,
              ),
              IconButton(
                  onPressed: () {
                    print("hello");
                  },
                  icon: const Icon(Icons.more_vert_rounded)),
            ],
          )
        ],
      ),
    );
  }

  Widget _sponsorBody(RouteModel route, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset20),
      child: Card.filled(
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        margin: const EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Images
              SizedBox(
                width: double.infinity,
                child: CachedImage(imageUrl: route.image ?? "")
                    .clipRRect(borderRadius: BorderRadius.circular(5)),
              ).expanded(flex: 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// ORIGIN & DESTINATION
                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                        size: 15,
                      ),
                      const SizedBox(
                        width: AppInsets.inset10,
                      ),
                      Text(
                        "${route.origin?.name ?? ""} to ${route.destination?.name ?? ""}",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 13),
                      ).expanded(),
                    ],
                  ).padding(padding: const EdgeInsets.only(bottom: 5)),

                  /// DATE
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range_rounded,
                        size: 15,
                      ),
                      const SizedBox(
                        width: AppInsets.inset10,
                      ),
                      Expanded(
                        child: Text(
                          DateTimeUtil.formatDateTime(route.scheduleDate),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 12),
                        ),
                      )
                    ],
                  ).padding(padding: const EdgeInsets.only(bottom: 5)),

                  /// MIDPOINTS
                  Row(
                    children: [
                      const Icon(
                        Icons.business_rounded,
                        size: 15,
                      ),
                      const SizedBox(
                        width: AppInsets.inset10,
                      ),
                      Text(
                        route.midpoints
                                ?.map((m) => m.city?.name)
                                .where((name) => name != null)
                                .join(' - ') ??
                            '',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 12),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ).expanded(),
                    ],
                  ).padding(padding: const EdgeInsets.only(bottom: 5)),

                  /// DESCRIPTION
                  Text(
                    route.description ?? "",
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                  ).expanded()
                ],
              )
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppInsets.inset5))
                  .expanded(flex: 3),

              /// Action Button
              ElevatedButton(
                onPressed: () => widget.onRoutePressed.call(route),
                child: Text(
                  "Book Now",
                  style: TextStyle(color: context.onPrimaryColor),
                ),
              ),

              /// short description
            ],
          ),
        ),
      ),
    );
  }
}
