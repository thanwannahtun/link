import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/domain/api_utils/search_routes_query.dart';
import 'package:link/models/post.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/custom_scaffold_body.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_insets.dart';
import '../../../domain/api_utils/api_query.dart';
import '../../../domain/bloc_utils/bloc_status.dart';
import '../../../domain/enums/category_type.dart';
import '../../screens/post_route_card.dart';
import '../../screens/route_detail_page.dart';
import '../../utils/route_list.dart';

class SearchQueryRoutes extends StatefulWidget {
  const SearchQueryRoutes({super.key});

  @override
  State<SearchQueryRoutes> createState() => _SearchQueryRoutesState();
}

class _SearchQueryRoutesState extends State<SearchQueryRoutes> {
  /// create model later
  SearchRoutesQuery? searchRoutesQuery;

  // create model later
  final List<RouteModel> _routes = [];
  late final PostRouteCubit _searchQueryCubit;
  bool _initial = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
/*{
  "origin": _originNotifier.value,
  "destination": _destinationNotifier.value,
  "date": _selectedDateNotifier.value
}*/
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        searchRoutesQuery =
            ModalRoute.of(context)?.settings.arguments as SearchRoutesQuery;

        _searchQueryCubit = context.read<PostRouteCubit>()
          ..getRoutesByCategory(
              query: APIQuery(
                  categoryType: CategoryType.searchedRoutes,
                  searchedRouteQuery: searchRoutesQuery));
      }
      _initial = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBody(
      backButton: BackButton(
        onPressed: () => context.pop(),
      ),
      body: _body(context),
      title: Text(
        "ReSuLtS",
        style: TextStyle(
            color: context.onPrimaryColor,
            fontSize: AppInsets.font25,
            fontWeight: FontWeight.bold),
      ),
      action: Row(
        children: [
          IconButton.filled(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    context.tertiaryColor.withOpacity(0.8)),
              ),
              onPressed: () {},
              icon: Icon(
                Icons.search_rounded,
                color: context.onPrimaryColor,
              ))
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppInsets.inset8, vertical: AppInsets.inset5),
      child: BlocConsumer<PostRouteCubit, PostRouteState>(
        bloc: _searchQueryCubit,
        builder: (BuildContext context, state) {
          debugPrint("::::::::::::: ${state.status}");
          if (state.status == BlocStatus.fetchFailed && _routes.isEmpty) {
            return _buildShimmer(context);
          } else if (state.status == BlocStatus.fetching && _routes.isEmpty) {
            return _buildShimmer(context);
          }
          final newRoutes = state.routeModels;
          debugPrint("=====> _posts before fetched ${_routes.length}");
          debugPrint("=====> newRoutes ${newRoutes.length}");
          _routes.addAll(newRoutes);
          debugPrint("=====> _routes afeter fetched ${_routes.length}");
          return _postViewBuilder();
        },
        listener: (BuildContext context, Object? state) {},
      ),
    );
  }

  Widget _postViewBuilder() {
    if (_routes.isEmpty) {
      return Center(
        child: Text(
                "No Routes for ${searchRoutesQuery?.origin?.name ?? ""} to ${searchRoutesQuery?.destination?.name} ! ")
            .padding(padding: const EdgeInsets.all(35)),
      );
    }
    return ListView.separated(
      itemCount: _routes.length,
      itemBuilder: (context, index) {
        // PostRouteCard(
        //  post: _routes[index],
        //  onAgencyPressed: () {
        //    context.pushNamed(RouteLists.publicAgencyProfile,
        //        arguments: _routes[index].agency);
        //  },
        // );

        return RouteInfoCardWidget(
          route: _routes[index],
          onRoutePressed: (route) {
            context.pushNamed(RouteLists.routeDetailPage, arguments: route);
          },
          onAgencyPressed: (route) {
            context.pushNamed(RouteLists.routeDetailPage, arguments: route);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: AppInsets.inset8,
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
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
          child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostRouteCard(
                post: const Post(),
                loading: true,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: AppInsets.inset8,
            ),
          ),
        ),
      ],
    );
  }
}
