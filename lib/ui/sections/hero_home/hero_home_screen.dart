import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/styles/app_theme.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/widgets/cached_image.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/api_utils/search_routes_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/ui/screens/route_detail_page.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../domain/enums/category_type.dart';
import '../../../models/city.dart';
import '../../widgets/custom_scaffold_body.dart';

class HeroHomeScreen extends StatefulWidget {
  const HeroHomeScreen({super.key});

  @override
  State<HeroHomeScreen> createState() => _HeroHomeScreenState();
}

class _HeroHomeScreenState extends State<HeroHomeScreen> {
  late final ValueNotifier<DateTime?> _selectedDateNotifier;

  List<RouteModel> _trendingRoutes = [];
  List<RouteModel> _sponsoredRoutes = [];

  late final PostRouteCubit _trendingRouteBloc;
  late final PostRouteCubit _sponsoredRouteBloc;

  final ValueNotifier<City?> _originNotifier = ValueNotifier(null);
  final ValueNotifier<City?> _destinationNotifier = ValueNotifier(null);

  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  final _originAutoCompleteController = CityAutocompleteController();
  final _destinationAutoCompleteController = CityAutocompleteController();

  @override
  void initState() {
    super.initState();
    print("initStateCalled  :HeroHomeScreen");
    _trendingRouteBloc = PostRouteCubit()
      ..getRoutesByCategory(
          query:
              APIQuery(categoryType: CategoryType.trendingRoutes, limit: 10));
    _sponsoredRouteBloc = PostRouteCubit()
      ..getRoutesByCategory(
          query:
              APIQuery(categoryType: CategoryType.sponsoredRoutes, limit: 10));
    _selectedDateNotifier = ValueNotifier(DateTime.now());

    _scrollController = ScrollController(); // _sponsoredRoute Controller
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("dependency changes");
  }

  void _onScroll() {
    if (_debounceTimer?.isActive ?? false) return; // Prevent further processing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_isBottom &&
          (_sponsoredRouteBloc.state.status != BlocStatus.fetching)) {
        print("_isBottom $_isBottom ");
        if (!(_sponsoredRoutes.length > 50)) {
          _sponsoredRouteBloc.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.sponsoredRoutes, limit: 5));
        }
      }
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.02; // Set a threshold of 2%
    // Check if the user is within the last 2% of the scrollable area
    return (maxScroll - currentScroll <= threshold);
    // return currentScroll >=
    //     (maxScroll * 0.98); // Trigger when scrolled 90% of the way
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    print("Equality ${_trendingRouteBloc == _sponsoredRouteBloc}");

    return CustomScaffoldBody(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          _sponsoredRoutes = [];
          _trendingRoutes = [];
          _sponsoredRouteBloc.updatePage(); // set page value to
          _trendingRouteBloc.updatePage(); // set page value to
          _trendingRouteBloc.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.trendingRoutes, limit: 10));
          // Todo: uncomment below
          _sponsoredRouteBloc.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.sponsoredRoutes, limit: 10));
        },
        child: _heroBody(context),
      ),
      title: Text(
        "Home",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: _actionWidgets(context),
    );
  }

  Row _actionWidgets(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            icon: Icon(
              Icons.notifications_rounded,
              color: context.onPrimaryColor,
            ))
      ],
    );
  }

  Widget _heroBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            _originDestinationCard(context),
            // Date Choice field
            _dateChoiceActionCard(),
            */
            // Container(
            //   padding: const EdgeInsets.only(bottom: AppInsets.inset5),
            //   margin: const EdgeInsets.all(0.0),
            //   color: Theme.of(context).cardColor.withOpacity(0.5),
            //   child: Column(
            //     children: [
            _originDestinationCard(context),
            // Date Choice field
            _dateChoiceActionCard(),
            //   ],
            // ).padding(padding: const EdgeInsets.all(5)),
            // ),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: AppInsets.inset5),
              margin: const EdgeInsets.all(0.0),
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: Column(
                children: [
                  _trendingSearchTitleField(context),
                  SizedBox(height: 200, child: _trendingRoutesList()),
                ],
              ).padding(padding: const EdgeInsets.all(5)),
            ),
            /*
            _trendingSearchTitleField(context),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            SizedBox(height: 130, child: _trendingRoutesList()),
            const SizedBox(
              height: 5,
            ),
            */
            const SizedBox(
              height: AppInsets.inset8,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: AppInsets.inset5),
              margin: const EdgeInsets.all(0.0),
              color: Theme.of(context).cardColor.withOpacity(0.5),
              child: Column(
                children: [
                  _sponsoredPostsTitleField(context),
                  const SizedBox(
                    height: AppInsets.inset8,
                  ),
                  SizedBox(height: 380, child: _sponsoredRoutesList()),
                  _sponsoredViewAllAction(context),
                ],
              ).padding(padding: const EdgeInsets.all(5)),
            ),
            /*
            _sponsoredPostsTitleField(context),
            const SizedBox(
              height: AppInsets.inset8,
            ),
            SizedBox(height: 350, child: _sponsoredRoutesList()),
          */
            const SizedBox(
              height: AppInsets.inset8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sponsoredRoutesList() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      bloc: _sponsoredRouteBloc,
      builder: (context, state) {
        debugPrint("::::::::::::: ${state.status}");
        if (state.status == BlocStatus.fetchFailed &&
            _sponsoredRoutes.isEmpty) {
          return _buildTrendingRoutesShimmer(context);
        } else if (state.status == BlocStatus.fetching &&
            _sponsoredRoutes.isEmpty) {
          return _buildTrendingRoutesShimmer(context);
        }
        final newRoutes = state.routeModels;
        print("new route first = ${newRoutes.first.toJson()}");
        print(
            "=====> _sponsoredRoutes before fetched ${_sponsoredRoutes.length}");
        print("=====> newRoutes ${newRoutes.length}");
        _sponsoredRoutes.addAll(newRoutes);
        print(
            "=====> _sponsoredRoutes afeter fetched ${_sponsoredRoutes.length}");

        return _buildSponsoredRoutesCard(context);
      },
      listener: (BuildContext context, PostRouteState state) {},
    );
  }

  Widget _trendingRoutesList() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
        bloc: _trendingRouteBloc,
        listener: (BuildContext context, Object? state) {},
        builder: (BuildContext context, state) {
          if (state.status == BlocStatus.fetchFailed ||
              state.status == BlocStatus.fetching) {
            return _buildTrendingRoutesShimmer(context);
          } else if (state.status == BlocStatus.fetched) {
            _trendingRoutes = state.routeModels;
            print("_trendingRoutes :::: ${_trendingRoutes.length}");
            return _buildTrendingRoutesCard(context);
          } else {
            return _buildTrendingRoutesShimmer(context);
          }
        });
  }

  Widget _trendingSearchTitleField(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Trending Search",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                context.pushNamed(RouteLists.trendingRouteCards);
              },
              icon: const Icon(Icons.keyboard_arrow_right_sharp)),
        ],
      ),
    );
  }

  Widget _sponsoredViewAllAction(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Opacity(
        opacity: 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "View All",
              style: GoogleFonts.robotoMono(
                fontSize: 12,
              ),
            ).styled(),
            const Icon(Icons.keyboard_double_arrow_right_outlined)
          ],
        ),
      ),
    );
  }

  Widget _sponsoredPostsTitleField(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Suggested For you",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
              onPressed: () {
                // context.pushNamed(RouteLists.trendingRouteCards);
              },
              icon: const Icon(Icons.keyboard_arrow_right_sharp)),
        ],
      ),
    );
  }

  Widget _buildSponsoredRoutesCard(BuildContext context) {
    if (_sponsoredRoutes.isEmpty) {
      return _showEmptyTrendingCard(context);
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemBuilder: (context, index) {
        // if (index < _sponsoredRoutes.length) {
        return _sponsoredCard(context, _sponsoredRoutes[index]);
        // } else {
        // return _showEmptyTrendingCard(context);
        // }
      },
      itemCount: _sponsoredRoutes.length,
    );
  }

  Widget _sponsoredCard(BuildContext context, RouteModel route) {
    print("route json ::: sponsored ${route.toJson()}");
    return InkWell(
      onTap: () {
        context.pushNamed(RouteLists.routeDetailPage, arguments: route);
      },
      child: Card.filled(
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1))),
        margin: const EdgeInsets.symmetric(
          horizontal: AppInsets.inset5,
        ),
        color: Theme.of(context).cardColor,
        child: Container(
          width: MediaQuery.sizeOf(context).width - 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.01,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// header
              Expanded(
                child: _sponsorHeader(route),
              ),

              Expanded(
                flex: 5,
                child: _sponsorBody(route, context),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _sponsorBody(RouteModel route, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset20),
      child: Card.filled(
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.zero)),
        margin: const EdgeInsets.all(0.0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              /// Images
              SizedBox(
                width: double.infinity,
                child: CachedImage(imageUrl: route.image ?? "")
                    .clipRRect(borderRadius: BorderRadius.circular(5)),
              ).expanded(flex: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: Theme.of(context).textTheme.titleSmall,
                      ).expanded(),
                    ],
                  ),

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
                      Text(
                        DateTimeUtil.formatDateTime(route.scheduleDate),
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    ],
                  ),

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
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                      ).expanded(),
                    ],
                  ),

                  /// DESCRIPTION
                  Text(
                    route.description ?? "",
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: true,
                  ).padding(padding: const EdgeInsets.all(AppInsets.inset5))
                ],
              )
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppInsets.inset5))
                  .expanded(flex: 3),

              /// Action Button
              ElevatedButton(
                style: AppTheme.elevatedButtonThemeData().style?.copyWith(
                    // minimumSize: WidgetStatePropertyAll(
                    //     Size(MediaQuery.of(context).size.width * 0.8, 35)),
                    ),
                onPressed: () {
                  context.pushNamed(RouteLists.routeDetailPage,
                      arguments: route);
                },
                child: Text(
                  "Book Now",
                  style: TextStyle(color: context.onPrimaryColor),
                ),
              )
                  .padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppInsets.inset8))
                  .expanded(),

              /// short description
            ],
          ),
        ),
      ),
    );
  }

  Padding _sponsorHeader(RouteModel route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  print("===> go to Agency Detail");
                  context.pushNamed(
                    RouteLists.publicAgencyProfile,
                    arguments: route.agency,
                  );
                },
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

  Widget _buildTrendingRoutesCard(BuildContext context) {
    if (_trendingRoutes.isEmpty) {
      return SizedBox(height: 150, child: _showEmptyTrendingCard(context));
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (index < _trendingRoutes.length) {
          RouteModel routeModel = _trendingRoutes[index];
          print("routeMOdel json = ${routeModel.toJson()}");
          return _trendingRouteCard(context, routeModel);
        }
        return _navigateToAllTrendingRoutes();
      },
      itemCount: _trendingRoutes.length + 1,
    );
  }

  Card _navigateToAllTrendingRoutes() {
    return Card.filled(
      child: TextButton.icon(
        onPressed: () {
          // _trendingRouteBloc.updatePage(); // set page value to
          _trendingRouteBloc.getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.trendingRoutes, limit: 10));
          print("View All Pressed!");
        },
        label: const Text("View All"),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.double_arrow_rounded),
      ).padding(
          padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5)),
    );
  }

  Widget _trendingRouteCard(
    BuildContext context,
    RouteModel routeModel,
  ) {
    print("routeModel ==== > card ${routeModel.toJson()}");
    Card.filled(
      elevation: 0.5,
      color: context.secondaryColor,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // Todo:
              //   context.pushNamed(RouteLists.trendingRouteCardDetail,
              //   arguments: routeModel);
            },
            child: Card.filled(
              shape: Border.all(width: 0.01),
              margin: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: NetworkImage(routeModel.image ?? ""),
                  fit: BoxFit.cover,
                  opacity: 0.5,
                  onError: (exception, stackTrace) => Container(
                    color: Colors.amber,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppInsets.inset10,
                      vertical: AppInsets.inset5),
                  child: SizedBox(
                    height: 80,
                    width: 250,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.bus_alert_rounded,
                              // color: context.primaryColor,
                            ),
                            const SizedBox(
                              width: AppInsets.inset5,
                            ),
                            Text(
                                "${routeModel.origin?.name ?? ""}-${routeModel.destination?.name ?? ""}"),
                          ],
                        ).expanded(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppInsets.inset10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.today_rounded,
                                    // color: context.primaryColor,
                                  ),
                                  const SizedBox(
                                    width: AppInsets.inset5,
                                  ),
                                  Text(DateTimeUtil.formatDateTime(
                                      routeModel.scheduleDate))
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: AppInsets.inset15,
                                    color: Colors.amber,
                                  ),
                                  Text(15.toString())
                                ],
                              ).expanded(),
                            ],
                          ),
                        ).expanded()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ).expanded(flex: 2),
          TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                        vertical: AppInsets.inset5,
                        horizontal: AppInsets.inset10)),
                  ),
                  onPressed: () {
                    context.pushNamed(RouteLists.trendingRouteCardDetail,
                        arguments: routeModel);
                    // context.pushNamed(RouteLists.trendingRouteCardDetail,
                    //     arguments: routeModel);
                  },
                  child: const Text("Book Now"))
              .expanded(),
        ],
      ),
    );

    return SizedBox(
        width: 330,
        child: GestureDetector(
          onTap: () {
            context.pushNamed(RouteLists.routeDetailPage,
                arguments: routeModel);
          },
          child: RouteDetailPage(
            route: routeModel,
          ),
        )
        /*
      Card.filled(
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Column(
          children: [
            /// header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RouteLists.publicAgencyProfile,
                          arguments: routeModel.agency,
                        );
                      },
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CachedImage(
                            imageUrl: routeModel.agency?.profileImage ?? ""),
                      ).clipRRect(borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RouteLists.publicAgencyProfile,
                          arguments: routeModel.agency,
                        );
                      },
                      child: Text(
                        routeModel.agency?.name ?? "",
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      DateTimeUtil.formatTime(context,
                          TimeOfDay.fromDateTime(routeModel.createdAt!)),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ).padding(padding: const EdgeInsets.only(left: 5, top: 5)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_outlined)),
              ],
            ).expanded(),

            /// image and routeModel info
            InkWell(
                onTap: () => context.pushNamed(
                    RouteLists.trendingRouteCardDetail,
                    arguments: routeModel),
                child: Row(
                  children: [
                    CachedImage(imageUrl: routeModel.image ?? "")
                        .clipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        )
                        .expanded(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "${routeModel.origin?.name ?? ""} - ${routeModel.destination?.name ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                routeModel.description ?? "",
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ).expanded(flex: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateTimeUtil.formatDateTime(
                                    routeModel.scheduleDate),
                                style: const TextStyle(fontSize: 10),
                              ),
                              Row(
                                children: [
                                  const Text("4").styled(fs: 13),
                                  Icon(
                                    Icons.star_sharp,
                                    color:
                                        context.successColor.withOpacity(0.7),
                                    size: 15,
                                  )
                                ],
                              ),
                            ],
                          ).expanded(),
                        ],
                      ),
                    ).expanded(),
                  ],
                )).padding(padding: const EdgeInsets.all(5)).expanded(flex: 4),
          ],
        ),
      ),
      */
        );
  }

  Widget _showEmptyTrendingCard(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: double.infinity,
            child: Center(
              child: Card.filled(
                child: SizedBox(
                  // width: MediaQuery.sizeOf(context).width - 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "There is no trending post available",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ).fittedBox(),
                      ElevatedButton(
                          onPressed: () =>
                              // context.pushNamed(RouteLists.postCreatePage),
                              _trendingRouteBloc.getRoutesByCategory(
                                  query: APIQuery(
                                      categoryType: CategoryType.trendingRoutes,
                                      limit: 5)),
                          child: const Text("Start Creating A Post!"))
                    ],
                  ).padding(padding: const EdgeInsets.all(AppInsets.inset8)),
                ),
              ),
            ),
          ).expanded(),
        ]);
  }

  Widget _buildTrendingRoutesShimmer(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: context.primaryColor,
        highlightColor: context.onPrimaryColor,
        child: Card.filled(
          elevation: 0.5,
          color: context.secondaryColor,
          child: Column(
            children: [
              const Card.filled(
                child: SizedBox(
                  // height: double.infinity,
                  width: 250,
                ),
              ),
              TextButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                        vertical: AppInsets.inset5,
                        horizontal: AppInsets.inset10)),
                  ),
                  onPressed: () {},
                  child: const Text("Book Now")),
            ],
          ),
        ),
      ),
      itemCount: 7,
    );
  }

  Card _dateChoiceActionCard() {
    return Card.filled(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppInsets.inset15, vertical: AppInsets.inset8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "When you want to go?",
                      ),
                      const SizedBox(
                        height: AppInsets.inset15,
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? value = await showDatePicker(
                              context: context,
                              initialDate: _selectedDateNotifier.value,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 10));
                          if (value != null) {
                            _selectedDateNotifier.value = value;
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_sharp,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppInsets.inset15),
                              child: ValueListenableBuilder<DateTime?>(
                                valueListenable: _selectedDateNotifier,
                                builder: (context, value, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: context.primaryColor,
                                                style: BorderStyle.solid))),
                                    child: Text(
                                        DateTimeUtil.formatDate(
                                            value ?? DateTime.now()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  /// How many people
                  // const Column(
                  //   children: [
                  //     Icon(Icons.arrow_drop_up_rounded),
                  //     Text('5'),
                  //     Icon(Icons.arrow_drop_down_rounded),
                  //   ],
                  // )
                ],
              ),
            ),
          ),

          /// search Icon
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: context.secondaryColor,
                  borderRadius: BorderRadius.circular(AppInsets.inset5)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppInsets.inset25),
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        print(
                            "${_originNotifier.value?.toJson()} - ${_destinationNotifier.value?.toJson()} ");
                        if (_originNotifier.value == null ||
                            _destinationNotifier.value == null) {
                          return;
                        }
                        context.pushNamed(
                          RouteLists.searchQueryRoutes,
                          arguments: SearchRoutesQuery(
                              origin: _originNotifier.value,
                              destination: _destinationNotifier.value,
                              date: _selectedDateNotifier.value),
                          // arguments: {
                          //   "origin": _originNotifier.value,
                          //   "destination": _destinationNotifier.value,
                          //   "date": _selectedDateNotifier.value
                          // },
                        );
                      },
                      icon: Icon(
                        color: context.onPrimaryColor,
                        size: AppInsets.inset35,
                        Icons.search_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _originDestinationCard(BuildContext context) {
    return Card.filled(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// from & to
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// FROM
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded),
                    const SizedBox(
                      width: AppInsets.inset25,
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: _originNotifier,
                        builder:
                            (BuildContext context, City? value, Widget? child) {
                          return CityAutocomplete(
                            cities: App.cities,
                            controller: _originAutoCompleteController,
                            onSelected: (city) {
                              _originNotifier.value = city;
                            },
                            border: InputBorder.none,
                            labelText: "Origin",
                            hintText: "From",
                          );
                          /*
                          return InkWell(
                            onTap: () async {
                              // City? city = await _chooseCity();

                              // if (city != null) {
                              //   _originNotifier.value = city;
                              // }
                            },
                            splashColor:
                                Colors.transparent, // Removes the splash effect
                            highlightColor: Colors
                                .transparent, // Removes the highlight effect
                            hoverColor: Colors.transparent,
                            child: Text(
                              value == null ? "Origin" : value.name.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ), // Removes the hover effect
                          );
                          */
                        },
                      ),
                      // child: TextField(
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      //   decoration: InputDecoration(
                      //     border: InputBorder.none,
                      //   ),
                      // ),
                    ),
                  ],
                ),

                /// DIVIDER
                Row(
                  children: [
                    const Icon(Icons.keyboard_double_arrow_down),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Divider(
                        indent: AppInsets.inset20,
                        thickness: 0.2,
                      ),
                    ),
                    const SizedBox(
                      width: AppInsets.inset5,
                    ),
                    InkWell(
                      onTap: () {
                        City? origin = _originNotifier.value;
                        City? destination = _destinationNotifier.value;
                        _originNotifier.value = destination;
                        _destinationNotifier.value = origin;
                        _destinationAutoCompleteController.text =
                            _originAutoCompleteController.text;
                        _originAutoCompleteController.text =
                            _destinationAutoCompleteController.text;
                      },
                      child: const Icon(
                        Icons.swap_vert_circle,
                        size: AppInsets.inset30,
                      ),
                    )
                  ],
                ),

                /// TO
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(
                      width: AppInsets.inset25,
                    ),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: _destinationNotifier,
                        builder:
                            (BuildContext context, City? value, Widget? child) {
                          return CityAutocomplete(
                            cities: App.cities,
                            controller: _destinationAutoCompleteController,
                            onSelected: (city) {
                              _destinationNotifier.value = city;
                            },
                            border: InputBorder.none,
                            labelText: "Destination",
                            hintText: "To",
                          );
                          /*
                          return InkWell(
                            splashColor:
                                Colors.transparent, // Removes the splash effect
                            highlightColor: Colors
                                .transparent, // Removes the highlight effect
                            hoverColor: Colors.transparent,
                            onTap: () async {
                              City? city = await _chooseCity();

                              if (city != null) {
                                _destinationNotifier.value = city;
                              }
                            },
                            child: Text(
                              value == null
                                  ? "Destination"
                                  : value.name.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                          */
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),

            /// filter

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppInsets.inset10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: selections.map((value) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) rebuild) {
                          return FilterChip(
                            color: WidgetStatePropertyAll(context.primaryColor),
                            label: Text(
                              value,
                              style: TextStyle(color: context.secondaryColor),
                            ),
                            selected: selectedHobbies.contains(value),
                            onSelected: (bool isSelected) {
                              print("selected");
                              rebuild(() {
                                if (isSelected) {
                                  selectedHobbies.add(value);
                                } else {
                                  selectedHobbies.remove(value);
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of all hobbies
  final List<String> selections = [
    "AC",
    "VIP",
    "Business",
    "Accomodation",
  ];

  // Set to hold selected hobbies
  Set<String> selectedHobbies = {};
}
