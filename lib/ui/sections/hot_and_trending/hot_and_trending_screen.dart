import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/city/city_cubit.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';
import 'package:shimmer/shimmer.dart';

class HotAndTrendingScreen extends StatefulWidget {
  const HotAndTrendingScreen({super.key});

  @override
  State<HotAndTrendingScreen> createState() => _HotAndTrendingScreenState();
}

class _HotAndTrendingScreenState extends State<HotAndTrendingScreen> {
  List<Post> posts = [];
  late PostRouteCubit _postRouteCubit;

  late final ScrollController _scrollController;
  @override
  void initState() {
    print("initStteCalled  :Hot_Trending");
    super.initState();
    _postRouteCubit = PostRouteCubit()..fetchRoutes();
    context.read<CityCubit>().fetchCities();
    // context.read<PostRouteCubit>().fetchRoutes();
    _listenRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _listenRefresh() async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent
            // && !_isLoadingMore
            ) {
          // If the end of the list is reached, trigger the refresh at the end
          _refreshAtEnd();
        }
      });
  }

  // Function to refresh when reaching the end
  Future<void> _refreshAtEnd() async {
    // setState(() {
    //   _isLoadingMore = true; // Indicate loading
    // });

    // Simulating network request delay
    await Future.delayed(const Duration(seconds: 2));

    // setState(() {
    //   items.addAll(List.generate(10, (index) => "New Item ${items.length + index}"));
    //   _isLoadingMore = false; // Reset the loading state
    // });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: RefreshIndicator.adaptive(
          onRefresh: () async {
            _postRouteCubit.fetchRoutes();
          },
          child: _body()),
      title: Text(
        "Trending Packages",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: IconButton(
          onPressed: () {},
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
        if (state.status == BlocStatus.fetchFailed) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetching) {
          return _buildShimmer(context);
        }
        posts = state.routes;
        return _showPosts();
      },
      listener: (context, state) {},
    );
  }

  Padding _showPosts() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppInsets.inset5, vertical: AppInsets.inset8),
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          Post post = posts[index];
          return PostRouteCard(
            post: post,
            onStarPressed: () => goPageDetail(post),
            onCommentPressed: () => goPageDetail(post),
            onAgencyPressed: () => context
                .pushNamed(RouteLists.trendingRouteCardDetail, arguments: post),
          );
        },
        itemCount: posts.length,
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 5,
        ),
      ),
    );
  }

  Future<Object?> goPageDetail(Post post) => Navigator.of(context)
      .pushNamed(RouteLists.postDetailPage, arguments: post);

  _buildShimmer(BuildContext context) {
    return ListView.builder(
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
