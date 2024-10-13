// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/bottom_select/bottom_select_cubit.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/app.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/utils/context.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';
import 'package:shimmer/shimmer.dart';

class HotAndTrendingScreen extends StatefulWidget {
  const HotAndTrendingScreen({super.key});

  @override
  State<HotAndTrendingScreen> createState() => _HotAndTrendingScreenState();
}

class _HotAndTrendingScreenState extends State<HotAndTrendingScreen> {
  List<Post> _trendingPosts = [];
  late PostRouteCubit _postRouteCubit;

  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  @override
  void initState() {
    print("initStateCalled  :HotAndTrendingScreen");
    super.initState();
    _postRouteCubit = PostRouteCubit()
      ..fetchRoutes(query: {"categoryType": "suggested", "limit": 10});
    context.read<CityCubit>().fetchCities();
    // context.read<PostRouteCubit>().fetchRoutes();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<BottomSelectCubit>().stream.listen(_onBottomDoubleSelect);
  }

  @override
  void didChangeDependencies() {
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

  void _onScroll() {
    if (_debounceTimer?.isActive ?? false) return; // Prevent further processing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_isBottom && (_postRouteCubit.state.status != BlocStatus.fetching)) {
        print("_isBottom $_isBottom ");
        _postRouteCubit
            .fetchRoutes(query: {"categoryType": "trending", "limit": 5});
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
          _postRouteCubit.updatePage(); // set page to default
          _trendingPosts = [];
          _postRouteCubit
              .fetchRoutes(query: {"categoryType": "suggested", "limit": 8});
        },
        // child: _customScrollViewWidget(),
        child: _body(),
      ),
      title: Text(
        "Trending Packages",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: IconButton(
          onPressed: () {
            _scrollController.animateTo(0,
                duration: const Duration(seconds: 1), curve: Curves.bounceIn);
          },
          icon: Icon(
            Icons.search,
            color: context.onPrimaryColor,
            size: AppInsets.inset30,
          )),
    );
  }

  BlocConsumer<PostRouteCubit, PostRouteState> _body() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      bloc: _postRouteCubit,
      builder: (context, state) {
        debugPrint("::::::::::::: ${state.status}");
        if (state.status == BlocStatus.fetchFailed && _trendingPosts.isEmpty) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetching &&
            _trendingPosts.isEmpty) {
          return _buildShimmer(context);
        }
        final newPosts = state.routes;
        print("=====> _trendingPosts before fetched ${_trendingPosts.length}");
        print("=====> newPosts ${newPosts.length}");
        _trendingPosts.addAll(newPosts);
        print("=====> _trendingPosts afeter fetched ${_trendingPosts.length}");

        return _showPosts();
      },
      listener: (context, state) {
        if (state.status == BlocStatus.fetchFailed &&
            _trendingPosts.isNotEmpty) {
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
    if (_trendingPosts.isEmpty) {
      return _showEmptyTrendingWidget();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
      child: Column(
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
                          onPressed: () => _postRouteCubit.fetchRoutes(
                              query: {"categoryType": "trending", "limit": 10}),
                          child: const Icon(Icons.refresh_rounded)),
                      const SizedBox(
                        height: 5,
                      ),
                      ElevatedButton(
                          onPressed: () =>
                              context.pushNamed(RouteLists.postCreatePage),
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

  ListView _buildSuggestionChips() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final city = App.cities[index];
        // Check if there is a next city
        final nextCityName = (index + 1 < App.cities.length)
            ? App.cities[index + 1].name
            : ""; // Prevent out-of-bounds access
        return Card.filled(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
                    (nextCityName?.isNotEmpty ?? false)
                        ? "${city.name} - $nextCityName"
                        : city.name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold))
                .padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset10))
                .center());
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 5,
      ),
      itemCount: App.cities.length,
    );
  }

  ListView _postViewBuilder() {
    return ListView.separated(
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index < _trendingPosts.length) {
          Post post = _trendingPosts[index];
          return PostRouteCard(
              post: post,
              onStarPressed: (isLiked) {
                isLiked != isLiked;
                // update LikeCounts
              },
              // isLike: true,
              onCommentPressed: () => goPageDetail(post),
              onPhotoPressed: () => goPageDetail(post),
              onAgencyPressed: () => goAgencyPage(post));
        } else {
          return PostRouteCard(
            post: Post(),
            loading: true,
          );
        }
      },
      itemCount: _trendingPosts.length +
          (_postRouteCubit.state.status == BlocStatus.fetching ? 3 : 0),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: AppInsets.inset8,
      ),
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
                    label: Text(" suggesstion "),
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
                    post: Post(),
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

final List<String> images = [
  "https://images.pexels.com/photos/1051072/pexels-photo-1051072.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/1051078/pexels-photo-1051078.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/3943882/pexels-photo-3943882.jpeg?auto=compress&cs=tinysrgb&w=600",
  "https://images.pexels.com/photos/54380/pexels-photo-54380.jpeg?auto=compress&cs=tinysrgb&w=600"
];

class ImagePageView extends StatelessWidget {
  const ImagePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.network(
          images[index],
          fit: BoxFit.contain,
        );
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
            Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity, // Ensure image takes full width
              height: double.infinity, // Ensure image takes full height
            ),
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
            background: Image.network(
              'https://images.pexels.com/photos/1051072/pexels-photo-1051072.jpeg?auto=compress&cs=tinysrgb&w=600',
              fit: BoxFit.cover,
            ),
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



/*



// Custom delegate to create a persistent header with pinned behavior
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}


  // ignore: unused_element
  BlocConsumer<PostRouteCubit, PostRouteState> _customScrollViewWidget() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      bloc: _postRouteCubit,
      listener: (BuildContext context, PostRouteState state) {},
      builder: (BuildContext context, PostRouteState state) {
        if (state.status == BlocStatus.fetchFailed) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetching) {
          return _buildShimmer(context);
        }
        posts = state.routes;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  minHeight: 40.0, // Minimum height when collapsed
                  maxHeight: 40.0, // Maximum height when expanded
                  child: Container(
                    color: Colors.white, // Background color
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final city = App.cities[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Chip(
                              label: Text(city.name ?? ""),
                              deleteIcon: const Icon(Icons.search),
                              onDeleted: () => print("Hello"),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                        itemCount: App.cities.length,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Post post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppInsets.inset5),
                      child: PostRouteCard(
                        post: post,
                        onStarPressed: () => goPageDetail(post),
                        onCommentPressed: () => goPageDetail(post),
                        onAgencyPressed: () => context.pushNamed(
                            RouteLists.trendingRouteCardDetail,
                            arguments: post),
                      ),
                    );
                  },
                  childCount: App.cities.length, // Number of main list items
                ),
              ),
            ],
          ),
        );
      },
    );
  }

 */