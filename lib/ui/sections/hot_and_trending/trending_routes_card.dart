import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/screens/post_route_card.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';

import '../../../domain/api_utils/api_query.dart';
import '../../../domain/enums/category_type.dart';
import '../../../models/app.dart';
import '../../utils/route_list.dart';

class TrendingRoutesCard extends StatefulWidget {
  const TrendingRoutesCard({super.key});

  @override
  State<TrendingRoutesCard> createState() => _TrendingRoutesCardState();
}

class _TrendingRoutesCardState extends State<TrendingRoutesCard> {
  late final PostRouteCubit _trendingRouteBloc;
  List<Post> _trendingRoutes = [];

  @override
  void initState() {
    super.initState();
    _trendingRouteBloc = context.read<PostRouteCubit>()
      ..getRoutesByCategory(
          query: APIQuery(categoryType: CategoryType.trendingRoutes, limit: 5));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      body: _body(context),
      backButton: BackButton(
        onPressed: () => context.pop(),
      ),
      title: Text(
        "Trending Routes",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      // backButton: BackButton(
      //   onPressed: () => context.pop(),
      // ),
      action: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.filter_alt,
            size: AppInsets.inset30,
            color: context.onPrimaryColor,
          )),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: BlocConsumer<PostRouteCubit, PostRouteState>(
        bloc: _trendingRouteBloc,
        listener: (BuildContext context, PostRouteState state) {},
        builder: (BuildContext context, PostRouteState state) {
          if (state.status == BlocStatus.fetched) {
            _trendingRoutes = state.routes;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppInsets.inset5),
                  child: SizedBox(
                    height: 50,
                    // color: Colors.amber,
                    child: _buildFilters(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppInsets.inset5),
                    child: _postViewBuilder(),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }

  ListView _postViewBuilder() {
    return ListView.builder(
      // itemCount: 10,
      itemCount: _trendingRoutes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppInsets.inset5),
          child: PostRouteCard(
            post: _trendingRoutes[index],
            onAgencyPressed: () => goAgencyPage(_trendingRoutes[index]),
            onPhotoPressed: () => goPageDetail(_trendingRoutes[index]),
          ),
        );
      },
    );
  }

  Future<Object?> goPageDetail(Post post) =>
      context.pushNamed(RouteLists.trendingRouteCardDetail, arguments: post);

  Future<Object?> goAgencyPage(Post post) =>
      context.pushNamed(RouteLists.publicAgencyProfile, arguments: post.agency);

  ListView _buildFilters() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
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
}
