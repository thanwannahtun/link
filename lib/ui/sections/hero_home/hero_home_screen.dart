import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/bloc/theme/theme_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/utils/date_time_util.dart';
import 'package:link/core/widgets/cached_image.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/ui/sections/upload/drop_down_autocomplete.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/city.dart';
import '../../../models/post.dart';
import '../../screens/post_route_card.dart';
import '../../utils/context.dart';
import '../../widgets/custom_scaffold_body.dart';

class HeroHomeScreen extends StatefulWidget {
  const HeroHomeScreen({super.key});

  @override
  State<HeroHomeScreen> createState() => _HeroHomeScreenState();
}

class _HeroHomeScreenState extends State<HeroHomeScreen> {
  late final ValueNotifier<DateTime?> _selectedDateNotifier;

  List<Post> _trendingRoutes = [];
  List<Post> _sponsoredRoutes = [];

  late final PostRouteCubit _trendingRouteBloc;
  late final PostRouteCubit _sponsoredRouteBloc;

  final ValueNotifier<City?> _originNotifier = ValueNotifier(null);
  final ValueNotifier<City?> _destinationNotifier = ValueNotifier(null);

  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    print("initStateCalled  :HeroHomeScreen");
    _trendingRouteBloc = PostRouteCubit()
      ..fetchRoutes(query: {"categoryType": "trending", "limit": 10});
    _sponsoredRouteBloc = PostRouteCubit()
      ..fetchRoutes(query: {"categoryType": "suggested", "limit": 8});
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
          _sponsoredRouteBloc
              .fetchRoutes(query: {"categoryType": "suggested", "limit": 5});
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
          _trendingRouteBloc
              .fetchRoutes(query: {"categoryType": "trending", "limit": 10});
          _sponsoredRouteBloc
              .fetchRoutes(query: {"categoryType": "sponsored", "limit": 7});
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
                  SizedBox(height: 130, child: _trendingRoutesList()),
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
        final newPosts = state.routes;
        print(
            "=====> _sponsoredRoutes before fetched ${_sponsoredRoutes.length}");
        print("=====> newPosts ${newPosts.length}");
        _sponsoredRoutes.addAll(newPosts);
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
          }
          if (state.status == BlocStatus.fetched) {
            _trendingRoutes = state.routes;
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

  Widget _sponsoredCard(BuildContext context, Post post) {
    return InkWell(
      onTap: () {
        print(" ===> go to sponseored post detail");
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
                child: _sponsorHeader(post),
              ),

              Expanded(
                flex: 5,
                child: _sponsorBody(post, context),
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

  Padding _sponsorBody(Post post, BuildContext context) {
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
                child: CachedImage(
                  imageUrl: (post.images?.firstOrNull == null)
                      ? ""
                      : "${App.baseImgUrl}${post.images?.first}",
                ).clipRRect(borderRadius: BorderRadius.circular(5)),
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
                        "${post.origin?.name ?? ""} to ${post.destination?.name ?? ""}",
                      ).styled(fw: FontWeight.bold).expanded(),
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
                      Text(DateTimeUtil.formatDateTime(post.scheduleDate))
                          .styled(fs: 12)
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
                        post.midpoints
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
                    post.description ?? "",
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
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none),
                    ),
                    backgroundColor:
                        WidgetStatePropertyAll(context.successColor),
                    minimumSize: WidgetStatePropertyAll(
                        Size(MediaQuery.of(context).size.width * 0.8, 35))),
                onPressed: () {
                  print("===> GO TO SPONSORED POST DETAIL");
                },
                child: Text(
                  "Action Button",
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

  Padding _sponsorHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "sponsored",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                "${(post.pricePerTraveler ?? 38000).toString()} Ks",
                style: const TextStyle(fontSize: 20),
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
                    arguments: post.agency,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child:
                        CachedImage(imageUrl: post.agency?.profileImage ?? "")
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
          Post post = _trendingRoutes[index];
          return _trendingRouteCard(context, post);
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
          _trendingRouteBloc.fetchRoutes(query: {
            "categoryType": "trending",
          });
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
    Post post,
  ) {
    Card.filled(
      elevation: 0.5,
      color: context.secondaryColor,
      child: Column(
        children: [
          InkWell(
            onTap: () => context.pushNamed(RouteLists.trendingRouteCardDetail,
                arguments: post),
            child: Card.filled(
              shape: Border.all(width: 0.01),
              margin: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: (post.images?.isNotEmpty == true)
                      ? NetworkImage("${App.baseImgUrl}${post.images?.first}")
                      : const AssetImage("assets/icon/app_logo.jpg"),
                  // image: NetworkImage((post.images?.isNotEmpty == true)
                  //     ? ((post.images?.firstOrNull != null)
                  //         ? "${App.baseImgUrl}${post.images?.first}"
                  //         : "https://images.pexels.com/photos/3278215/pexels-photo-3278215.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1")
                  //     : "https://images.pexels.com/photos/3278215/pexels-photo-3278215.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
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
                                "${post.origin?.name ?? ""}-${post.destination?.name ?? ""}"),
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
                                      post.scheduleDate))
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: AppInsets.inset15,
                                    color: Colors.amber,
                                  ),
                                  Text(post.commentCounts.toString())
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
                        arguments: post);
                    // context.pushNamed(RouteLists.trendingRouteCardDetail,
                    //     arguments: post);
                  },
                  child: const Text("Book Now"))
              .expanded(),
        ],
      ),
    );

    return SizedBox(
      width: 333,
      child: Card.filled(
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
                          arguments: post.agency,
                        );
                      },
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CachedImage(
                            imageUrl: post.agency?.profileImage ?? ""),
                      ).clipRRect(borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RouteLists.publicAgencyProfile,
                          arguments: post.agency,
                        );
                      },
                      child: Text(
                        post.agency?.name ?? "",
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      DateTimeUtil.formatTime(
                          context, TimeOfDay.fromDateTime(post.createdAt!)),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ).padding(padding: const EdgeInsets.only(left: 5, top: 5)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_outlined)),
              ],
            ).expanded(),

            /// image and post info
            InkWell(
                onTap: () => context.pushNamed(
                    RouteLists.trendingRouteCardDetail,
                    arguments: post),
                child: Row(
                  children: [
                    CachedImage(
                            imageUrl: (post.images?.isNotEmpty == true)
                                ? "${App.baseImgUrl}${post.images?.first}"
                                : "")
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
                                "${post.origin?.name ?? ""} - ${post.destination?.name ?? ""}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                post.title ?? "",
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
                                DateTimeUtil.formatDateTime(post.scheduleDate),
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
                        "Their is no trending post available",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center,
                      ).fittedBox(),
                      ElevatedButton(
                          onPressed: () =>
                              // context.pushNamed(RouteLists.postCreatePage),
                              _trendingRouteBloc.fetchRoutes(query: {
                                "categoryType": "trending",
                                "limit": 5
                              }),
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
                        context.pushNamed(RouteLists.searchQueryRoutes,
                            arguments: {
                              "origin": _originNotifier.value,
                              "destination": _destinationNotifier.value,
                              "date": _selectedDateNotifier.value
                            });
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
                            controller: CityAutocompleteController(),
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
                            controller: CityAutocompleteController(),
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

  Future<City?> _chooseCity() async {
    return await Context.showAlertDialog<City>(
      context,
      icon: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      headerWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text("Choose Cities").styled(fw: FontWeight.bold),
          ),
          CityAutocomplete(
            cities: App.cities,
            controller: CityAutocompleteController(),
            onSelected: (city) {
              print(city);
            },
            hintText: "Search",
          )
        ],
      ),
      itemList: App.cities,
      itemBuilder: (ctx, index) {
        if (index < 0) {
          return Center(
            child: IconButton(
                onPressed: () {
                  context.read<CityCubit>().fetchCities();
                },
                icon: const Icon(Icons.refresh_rounded)),
          );
        }
        return StatefulBuilder(
          builder: (BuildContext ctx, void Function(void Function()) setState) {
            return ListTile(
              dense: true,
              onTap: () {
                setState(() {});
                Navigator.pop(context, App.cities[index]);
              },
              // leading: const Icon(Icons.add_circle_outlined),
              title: Text(App.cities[index].name ?? ""),
            );
          },
        );
      },
    );
  }
}
