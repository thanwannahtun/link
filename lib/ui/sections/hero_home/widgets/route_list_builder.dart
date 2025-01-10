import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/extensions/util_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/core/utils/app_insets.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/bloc_utils/bloc_status.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/route_list.dart';
import 'package:link/ui/widget_extension.dart';
import 'package:link/ui/widgets/route_card_widgets/widgets/route_card_widget.dart';
import 'package:link/ui/widgets/route_fetched_widgets/route_fetched_widgets.dart';
import 'package:shimmer/shimmer.dart';

class RoutesListBuilder extends StatefulWidget {
  /// Generic Widget for showing Widgets based on the [Cubit] or [Bloc] states
  ///
  /// [RouteFetchedFailWidget] , [RouteFetchingWidget] , [RouteFetchedEmptyWidget]
  ///
  /// Optional [arguments] for [Data] passing down which will be accessed by [RouteCardWidget] as it's [argument]
  ///

  const RoutesListBuilder({
    super.key,
    required this.categoryType,
    required this.fetchRoutes,
    this.arguments, // Optional extra arguments
  });

  final CategoryType categoryType;
  final Future<void> Function(APIQuery query) fetchRoutes;
  final dynamic arguments; // Extra arguments to pass to RouteCardWidget

  @override
  State<RoutesListBuilder> createState() => _RoutesListBuilderState();
}

class _RoutesListBuilderState extends State<RoutesListBuilder> {
  late final ScrollController _scrollController;
  Timer? _debounceTimer;
  late PostRouteCubit _postRouteCubit;

  List<RouteModel> _fetchedRoutes = [];

  static const double _scrollThreshold =
      0.9; // Threshold to trigger fetch at 90% scroll

  @override
  void initState() {
    _postRouteCubit = context.read<PostRouteCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (!_isBottom ||
        _postRouteCubit.state.status == BlocStatus.fetching ||
        _postRouteCubit.state.routeModels.length > 50) {
      return;
    }

    // Debounce to prevent excessive fetch calls
    if (_debounceTimer?.isActive ?? false) return;
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_isBottom) {
        widget.fetchRoutes(
          APIQuery(categoryType: widget.categoryType, limit: 5),
        );
      }
    });
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * _scrollThreshold);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostRouteCubit, PostRouteState>(
      builder: (context, state) {
        if (state.status == BlocStatus.fetchFailed) {
          return const RouteFetchedFailWidget();
        } else if (state.status == BlocStatus.fetching &&
            state.routeModels.isEmpty) {
          return const RouteFetchingWidget();
        } else if (state.status == BlocStatus.fetched &&
            state.routeModels.isEmpty) {
          return RouteFetchedEmptyWidget(
              onActionPressed: () =>
                  context.pushNamed(RouteLists.uploadNewPost));
        } else if (state.status == BlocStatus.fetched) {
          /// append the new fetched routes
          _fetchedRoutes = state.routeModels;
        }
        return _buildRoutesList();
      },
    );
  }

  Widget _buildRoutesList() {
    int itemCount = _fetchedRoutes.length +
        (_postRouteCubit.state.status == BlocStatus.fetching ? 3 : 1);

    return ListView.builder(
      key: const Key('route-list-key'),
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index < _fetchedRoutes.length) {
          return RouteCardWidget(
            route: _fetchedRoutes[index],
            categoryType: widget.categoryType,
            arguments: widget.arguments,
          );
        } else {
          return LoadingBuilderWithPlaceHolderWidget(
            key: const Key('loading-builder-with-placeholder-key'),
            onPlaceHolderPressed: () {
              _navigateToAllRoutes(context);
            },
            reachMaxExtend:
                !(_postRouteCubit.state.status == BlocStatus.fetching) &&
                    (_postRouteCubit.state.routeModels.length > 50),
          );
        }
      },
      itemCount: itemCount,
    );
  }

  void _navigateToAllRoutes(BuildContext context) {
    APIQuery query = APIQuery(
      categoryType: widget.categoryType,
      limit: 10,
      page: context.read<PostRouteCubit>().getPage,
    );
    context.pushNamed(
      RouteLists.hotAndTrendingScreen,
      arguments: {"query": query},
    );
  }
}

class LoadingBuilderWithPlaceHolderWidget extends StatelessWidget {
  /// Loading Builder like [Shimmer] effect when loading state &
  /// show [Placeholder] Widget when [reachMaxExtend] return true
  const LoadingBuilderWithPlaceHolderWidget(
      {super.key, this.onPlaceHolderPressed, required this.reachMaxExtend});

  ///
  /// [Placehoder widget] shown if [reachMaxExtend] is true
  ///
  final VoidCallback? onPlaceHolderPressed;

  /// if **reachMaxExtend** return [true] , show the placeholder widget
  ///
  /// which has [onPlaceHolderPressed] callback
  ///
  final bool reachMaxExtend;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (reachMaxExtend) {
          return Card.filled(
            key: const Key('route-list-builder-reach-max-extend-key'),
            child: Container(
              margin: const EdgeInsets.all(AppInsets.inset10),
              padding: const EdgeInsets.all(AppInsets.inset10),
              color: context.greyFilled,
              width: _cardWidth(context),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Icon(
                      Icons.content_paste_search,
                      size: 50,
                    ),
                  ).expanded(),
                  TextButton.icon(
                    onPressed: onPlaceHolderPressed,
                    label: const Text("View All"),
                    style: Theme.of(context).elevatedButtonTheme.style,
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.double_arrow_rounded),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          key: const Key('route-list-builder-shimmer-key'),
          width: _cardWidth(context),
          child: Shimmer.fromColors(
            baseColor: context.greyColor,
            highlightColor: context.greyFilled,
            child: Card.filled(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: context.greyFilled,
                ),
                padding: const EdgeInsets.all(AppInsets.inset10),
                width: _cardWidth(context),
                height: double.infinity,
              ),
            ),
          ),
        );
      },
    );
  }

  double _cardWidth(BuildContext context) {
    double screenWidth = context.screenWidth;

    return context.isTablet
        ? screenWidth * 0.5
        : context.isDesktop
            ? screenWidth * 0.33
            : screenWidth * 0.8;
  }
}
