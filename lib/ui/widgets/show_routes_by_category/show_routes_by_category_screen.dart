// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/core/widgets/cached_image.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/api_utils/search_routes_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/models/app.dart';
import 'package:link/models/city.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/screens/profile/route_model_card.dart';
import 'package:link/ui/screens/route_detail_page.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';
import 'package:shimmer/shimmer.dart';

class ShowRoutesByCategoryScreen extends StatefulWidget {
  const ShowRoutesByCategoryScreen({super.key});

  @override
  State<ShowRoutesByCategoryScreen> createState() =>
      _ShowRoutesByCategoryScreenState();
}

class _ShowRoutesByCategoryScreenState
    extends State<ShowRoutesByCategoryScreen> {
  List<Post> _trendingPosts = [];
  List<RouteModel> _trendingRoutes = [];
  late PostRouteCubit _postRouteCubit;

  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  bool _initial = true;
  bool _pushedRoutePage = false;
  APIQuery? query;

  /// For initial Hot & Trending Tab query
  late APIQuery initialQuery;
  late APIQuery getPostWithRouteQuery;

  @override
  void initState() {
    print("initStateCalled  :HotAndTrendingScreen");
    super.initState();
    initialQuery = APIQuery(categoryType: CategoryType.trendingRoutes);
    getPostWithRouteQuery = APIQuery(categoryType: CategoryType.postWithRoutes);

    _postRouteCubit = context.read<PostRouteCubit>();
    context.read<CityCubit>().fetchCities();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<BottomSelectCubit>().stream.listen(_onBottomDoubleSelect);
  }

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final arguments =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        query = arguments['query'];
        if (query?.page != null) _postRouteCubit.updatePage(value: query?.page);
        _postRouteCubit.getRoutesByCategory(query: query ?? initialQuery);

        _pushedRoutePage = true;
      } else if (ModalRoute.of(context)?.settings.arguments == null) {
        _postRouteCubit.getRoutesByCategory(query: initialQuery);
      }

      _initial = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel(); // Cancel the timer on dispose
    super.dispose();
  }

  void _onBottomDoubleSelect(NavigationStates event) {
    print(event);
    if (mounted) {
      if (event == NavigationStates.B) {
        print(
            "[NavigationStates] State Equal ::: ${event == context.read<BottomSelectCubit>().state} ");
        if (context.read<BottomSelectCubit>().state == NavigationStates.B) {
          print("[NavigationStates] Hello World! ");
          // Update the UI conditionally
        }
      }
    }
  }

  // int _fetchToggle = 0; // Counter to alternate between fetches

  void _onScroll() {
    if (_debounceTimer?.isActive ?? false) {
      return; // Prevent multiple calls in quick succession
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_isBottom && (_postRouteCubit.state.status != BlocStatus.fetching)) {
        print("_isBottom $_isBottom ");

        // if (_fetchToggle % 2 == 0) {
        if (_postRouteCubit.getPage % 4 == 0) {
          // Fetch vertical list
          _postRouteCubit.getRoutesByCategory(query: query ?? initialQuery);
        } else {
          print("fetched for post with routes");

          // Fetch horizontal list (posts with routes)
          _postRouteCubit.getPostWithRoutes(query: getPostWithRouteQuery);
        }

        // _fetchToggle++; // Alternate fetch toggle
        // _postRouteCubit.updatePage(value: (_postRouteCubit.getPage + 1));

        // Fetch more routes for the vertical list
        // _postRouteCubit.getRoutesByCategory(
        //     query: {"categoryType": CategoryType.postWithRoutes, "limit": 5});
        //
        // // Fetch posts for the horizontal list every second scroll
        // if (_postRouteCubit.getPage % 2 == 0) {
        //   print("------------------ getPostWithRoutes------------");
        //   _postRouteCubit.getPostWithRoutes(
        //       query: {"categoryType": "post_with_routes", "limit": 5});
        // }
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
    return CustomScaffoldBody(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          // _postRouteCubit.updatePage(); // set page to default
          _trendingPosts = [];
          _trendingRoutes = [];
          _postRouteCubit.getRoutesByCategory(query: query ?? initialQuery);
        },
        // child: _customScrollViewWidget(),
        child: _body(),
      ),
      backButton: _pushedRoutePage
          ? BackButton(
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(
        (query?.categoryType?.title) ??
            (initialQuery.categoryType?.title ?? ""),
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: IconButton(
          onPressed: () {
            // _scrollController.animateTo(0,
            //     duration: const Duration(seconds: 1), curve: Curves.bounceIn);
            SearchRoutesQuery searchedRouteQuery = SearchRoutesQuery(
              origin: getRandomCity(),
              destination: getRandomCity(),
            );
            query = APIQuery(
                categoryType: CategoryType.searchedRoutes,
                searchedRouteQuery: searchedRouteQuery);
            context.pushNamed(RouteLists.searchRoutesScreen,
                arguments: {"query": query});
          },
          icon: Icon(
            Icons.search,
            color: context.onPrimaryColor,
            size: AppInsets.inset30,
          )),
    );
  }

  /// For Temporary Purpose
  City getRandomCity() {
    final random = Random();
    int randomIndex =
        random.nextInt(App.cities.length); // Generate a random index
    return App.cities[randomIndex]; // Return the random City object
  }

  BlocConsumer<PostRouteCubit, PostRouteState> _body() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      bloc: _postRouteCubit,
      builder: (context, state) {
        debugPrint("::::::::::::: ${state.status}");
        if (state.status == BlocStatus.fetchFailed && _trendingRoutes.isEmpty) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetching &&
            // _trendingPosts.isEmpty) {
            _trendingRoutes.isEmpty) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetched) {
          _trendingPosts = state.routes;
          _trendingRoutes = state.routeModels;
        }

        return _showPosts();

        // final newPosts = state.routes;
        // final newRoutes = state.routeModels;
        // if (_postRouteCubit.getPage % 4 == 0) {
        //   _trendingPosts.addAll(newPosts);
        // }
        // if (!(_postRouteCubit.getPage % 4 == 0)) {
        //   _trendingRoutes.addAll(newRoutes);
        // }
        //
        // print("=====> newRoutes ${newRoutes.length}");
        //
        // // final newPosts = state.routes;
        // print("=====> _trendingRoutes after fetched ${_trendingRoutes.length}");
        //
        // return _showPosts();
      },
      listener: (context, state) {
        if (state.status == BlocStatus.fetchFailed &&
            // _trendingPosts.isNotEmpty) {
            _trendingRoutes.isNotEmpty) {
          context.showSnackBar(SnackBar(
            content: Text(state.error ?? "Internet Connection Error!"),
          ));
        }
        /*
        if (state.status == BlocStatus.fetchFailed) {
          context.showSnackBar(
            SnackBar(
              content: Text(state.error ?? "Internet Connection Error!!"),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                  label: "Retry",
                  onPressed: () {
                    _postRouteCubit.fetchRoutes(
                        query: {"categoryType": "trending", "limit": 10});
                  }),
            ),
          );
        }
        */
      },
    );
  }

  Widget _showPosts() {
    // if (_trendingPosts.isEmpty) {
    if (_trendingRoutes.isEmpty) {
      return _showEmptyTrendingWidget();
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildSliverAppBar(context),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Insert widget every 15 items or based on other conditions
                final shouldShowHorizontalWidget = (index % 15 == 0) &&
                    index != 0 &&
                    _trendingPosts.isNotEmpty;

                if (shouldShowHorizontalWidget) {
                  return HorizontalPostWithRoutesWidget(
                    posts: _trendingPosts,
                    onFetchAllPressed: () {
                      _postRouteCubit.getPostWithRoutes(
                          query: getPostWithRouteQuery);
                    },
                  );
                }

                // Calculate the actual index considering additional horizontal widgets
                final adjustedIndex = index - (index ~/ 15);

                if (adjustedIndex >= 0 &&
                    adjustedIndex < _trendingRoutes.length) {
                  RouteModel route = _trendingRoutes[adjustedIndex];
                  return RouteInfoCardWidget(
                    route: route,
                    onRoutePressed: (route) {
                      context.pushNamed(RouteLists.routeDetailPage,
                          arguments: route);
                    },
                    onAgencyPressed: (route) {
                      context.pushNamed(RouteLists.publicAgencyProfile,
                          arguments: route.agency);
                    },
                  );
                }

                // Fallback for invalid index
                return Shimmer.fromColors(
                  baseColor: context.greyColor,
                  highlightColor: context.greyFilled,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Card(),
                  ),
                );
              },
              childCount: _trendingRoutes.isNotEmpty
                  ? _trendingRoutes.length +
                      (_trendingRoutes.length ~/ 15) +
                      (_postRouteCubit.state.status == BlocStatus.fetching
                          ? 3
                          : 0)
                  : 0,
            )),
          ],
        )
        /*
      Column(
        children: [
          SizedBox(
            height: 45,
            child: _buildSuggestionChips(),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
            child: _postViewBuilder(),
          )),
        ],
      ),
      */
        );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      // pinned: true,
      // expandedHeight: 20.0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          title: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Chip(
              label: Text(
                "Yangon to ${index + 1}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              labelPadding: EdgeInsets.zero,
              color: WidgetStatePropertyAll(context.greyFilled),
            ),
            itemCount: 10,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 5),
          )),
    );
  }

  Column _showEmptyTrendingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Card.filled(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppInsets.inset25, vertical: AppInsets.inset35),
              child: Column(
                children: [
                  const Text(
                    "There is no Trending Posts for you",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: AppInsets.inset10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () => _postRouteCubit.getRoutesByCategory(
                              query: query ?? initialQuery),
                          child: const Icon(Icons.refresh_rounded)),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              context.pushNamed(RouteLists.uploadNewPost),
                          child: const Text("Start Creating A Post!")),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<Object?> goPageDetail(Post post) =>
      context.pushNamed(RouteLists.trendingRouteCardDetail, arguments: post);

  Future<Object?> goAgencyPage(Post post) =>
      context.pushNamed(RouteLists.publicAgencyProfile, arguments: post.agency);

  // Navigator.of(context)
  // .pushNamed(RouteLists.postDetailPage, arguments: post);

  _buildShimmer(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Shimmer.fromColors(
                  baseColor: context.primaryColor,
                  highlightColor: context.onPrimaryColor,
                  child: const Chip(
                    label: Text(" suggestion "),
                    deleteIcon: Icon(Icons.search),
                  ),
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: 10,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: context.primaryColor,
                highlightColor: context.onPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PostRouteCard(
                    post: const Post(),
                    loading: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

final List<String> images = [];

class ImagePageViewBuilder extends StatelessWidget {
  const ImagePageViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return CachedImage(imageUrl: images[index]);
      },
    );
  }
}

class HorizontalScrollableListWidget extends StatelessWidget {
  const HorizontalScrollableListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 250.0, // Adjust based on image size
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.network(images[index]),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => const Text("hello"),
              itemCount: 40,
            ),
          )
        ],
      ),
    );
  }
}

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            CachedImage(imageUrl: images[index]),
            const Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Icon(Icons.play_arrow, color: Colors.white, size: 30.0),
            ),
          ],
        );
      },
    );
  }
}

class SliverGridWidget extends StatelessWidget {
  const SliverGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          flexibleSpace: FlexibleSpaceBar(
            background: CachedImage(imageUrl: ""),
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Image.network(images[index]);
            },
            childCount: images.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
        ),
      ],
    );
  }
}

class HorizontalPostWithRoutesWidget extends StatelessWidget {
  final List<Post> posts;
  final VoidCallback? onFetchAllPressed;

  const HorizontalPostWithRoutesWidget(
      {super.key, required this.posts, this.onFetchAllPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Height of the horizontal list
      child: posts.isEmpty
          ? Container(
              color: Colors.amber,
              height: double.infinity,
              width: MediaQuery.sizeOf(context).width - 10,
            )
          : CustomScrollView(
              scrollDirection: Axis.horizontal,
              key: const PageStorageKey('HorizontalPostWithRoutesWidget'),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index < posts.length) {
                        final post = posts[index];
                        return buildHorizontalRouteCard(context, post);
                      }
                      return SizedBox(
                        width: 200,
                        height: double.infinity,
                        child: Card(
                          child: Center(
                            child: ElevatedButton(
                                onPressed: onFetchAllPressed,
                                child: const Text("See All")),
                          ),
                        ),
                      );
                    },
                    childCount: posts.length + 1,
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildHorizontalRouteCard(BuildContext context, Post post) {
    return Card(
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(1))),
      child: SizedBox(
        width: 300,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RouteHeader(
              route: post.routes?.firstOrNull ?? const RouteModel(),
              onAgencyPressed: (route) {
                context.pushNamed(RouteLists.publicAgencyProfile,
                    arguments: route.agency);
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(RouteLists.routeDetailPage,
                      arguments: post.routes?.firstOrNull);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          post.description ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: context.greyColor),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: (post.routes?.isNotEmpty ?? false)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomScrollView(
                                scrollDirection: Axis.horizontal,
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int routeIndex) {
                                        final route =
                                            post.routes![routeIndex]; // Safe
                                        return Center(
                                          child: SizedBox(
                                            width: 250,
                                            height: double.infinity,
                                            child: RouteInfoBodyWithImage(
                                                onBookPressed: (route) {
                                                  context.pushNamed(
                                                      RouteLists
                                                          .routeDetailPage,
                                                      arguments: route);
                                                },
                                                route: route),
                                          ),
                                        );
                                        /*
                                          Card.filled(
                                          color: context.greyFilled,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: RouteInfoBodyWithImage(
                                              route: route),
                                        );
                                        */
                                      },

                                      childCount: post.routes!
                                          .length, // Use the actual length
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              width: 250,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green)),
                              child: CachedImage(
                                  imageUrl: post.agency?.profileImage ?? ""),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            RouteFooter(
              route: post.routes?.firstOrNull ?? const RouteModel(),
              onBookPressed: (RouteModel route) {
                context.pushNamed(RouteLists.routeDetailPage, arguments: route);
              },
            )
          ],
        ),
      ),
    );
  }
}
