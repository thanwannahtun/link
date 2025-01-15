import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link/bloc/routes/post_route_cubit.dart';
import 'package:link/core/extensions/navigator_extension.dart';
import 'package:link/core/theme_extension.dart';
import 'package:link/domain/api_utils/api_query.dart';
import 'package:link/domain/api_utils/search_routes_query.dart';
import 'package:link/domain/enums/category_type.dart';
import 'package:link/ui/screens/route_detail_page.dart';
import 'package:link/ui/sections/upload/route_array_upload/route_model/route_model.dart';
import 'package:link/ui/utils/context.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/app_insets.dart';
import '../../../domain/bloc_utils/bloc_status.dart';
import '../../../models/app.dart';
import '../../../models/post.dart';
import '../../screens/post_route_card.dart';
import '../../utils/route_list.dart';
import '../../widgets/location_swap.dart';
import '../upload/drop_down_autocomplete.dart';
import '../../../models/city.dart';

class SearchRoutesScreen extends StatefulWidget {
  const SearchRoutesScreen({super.key});

  @override
  State<SearchRoutesScreen> createState() => _SearchRoutesScreenState();
}

class _SearchRoutesScreenState extends State<SearchRoutesScreen> {
  late final ScrollController _scrollController;
  Timer? _debounceTimer;

  List<RouteModel> _searchedRoutes = [];
  late PostRouteCubit _searchedRouteCubit;

  @override
  void initState() {
    super.initState();
    _searchedRouteCubit = context.read<PostRouteCubit>();

    debugPrint("initStateCalled  :HeroHomeScreen");
    _scrollController = ScrollController(); // _sponsoredRoute Controller
    _scrollController.addListener(_onScroll);
  }

  bool _initial = true;
  APIQuery? _apiQuery;
  late SearchRoutesQuery? _searchedRouteQuery;

  @override
  void didChangeDependencies() {
    if (_initial) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final arguments =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        _apiQuery = arguments['query'];
        if (_apiQuery?.searchedRouteQuery != null) {
          _searchedRouteQuery = _apiQuery?.searchedRouteQuery;
        }
      } else if (ModalRoute.of(context)?.settings.arguments == null) {
        _searchedRouteQuery = SearchRoutesQuery(
          origin: App.cities.first,
          destination: App.cities.last,
        );
        _apiQuery = APIQuery(
            limit: 5,
            categoryType: CategoryType.searchedRoutes,
            searchedRouteQuery: _searchedRouteQuery);
      }
      _searchedRouteCubit.getRoutesByCategory(query: _apiQuery);
      _initial = false;
    }

    super.didChangeDependencies();
  }

  void _onScroll() {
    if (_debounceTimer?.isActive ?? false) return; // Prevent further processing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_isBottom) {}
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom SliverAppBar with embedded search fields
            _buildSliverAppBar(context),
            // Dummy content to simulate scrolling
            _body(),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      expandedHeight: 250.0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).cardColor,
      flexibleSpace: FlexibleSpaceBar(
        // title: Text(),
        background: Column(
          children: [
            _flexibleSpaceBarBackground(context),
          ],
        ),
      ),
    );
  }

  Widget _flexibleSpaceBarBackground(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: LocationSwap(
          initialOrigin: _searchedRouteQuery?.origin,
          initialDestination: _searchedRouteQuery?.destination,
          initialDate: _searchedRouteQuery?.date,
          onSearchRouteCallBack: (origin, destination, date) {
            _fetchAvailableRoutes(origin, destination, date);
          },
        ),
      ),
    );
  }

  /// ignore: unused_element
  Stack _flexibleSpaceBarBackgroundTemp(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image.network(
        //   'https://plus.unsplash.com/premium_photo-1671358446946-8bd43ba08a6a?q=80&w=1632&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        //   fit: BoxFit.cover,
        // ),
        Container(color: Theme.of(context).cardTheme.color),
        Positioned(
          bottom: 6.0,
          left: 8.0,
          right: 8.0,
          top: 6,
          child: Expanded(
            // padding: const EdgeInsets.all(16.0),
            child: LocationSwap(
              initialOrigin: _searchedRouteQuery?.origin,
              initialDestination: _searchedRouteQuery?.destination,
              initialDate: _searchedRouteQuery?.date,
              onSearchRouteCallBack: (origin, destination, date) {
                _fetchAvailableRoutes(origin, destination, date);
              },
            ),
          ),
        ),
      ],
    );
  }

  _fetchAvailableRoutes(City? origin, City? destination, DateTime? date) async {
    debugPrint("${origin?.toJson()} - ${destination?.toJson()} ");
    if (origin == null || destination == null) {
      return;
    }
    _searchedRoutes.clear();

    SearchRoutesQuery searchedRouteQuery =
        SearchRoutesQuery(origin: origin, destination: destination, date: date);

    _searchedRouteCubit.getRoutesByCategory(
      query: _apiQuery?.copyWith(searchedRouteQuery: searchedRouteQuery),
    );
  }

  BlocConsumer<PostRouteCubit, PostRouteState> _body() {
    return BlocConsumer<PostRouteCubit, PostRouteState>(
      bloc: _searchedRouteCubit,
      builder: (context, state) {
        debugPrint("::::::::::::: ${state.status}");
        // if (state.status == BlocStatus.fetchFailed && _trendingPosts.isEmpty) {
        if (state.status == BlocStatus.fetchFailed && _searchedRoutes.isEmpty) {
          return _buildShimmer(context);
        } else if (state.status == BlocStatus.fetching &&
            // _trendingPosts.isEmpty) {
            _searchedRoutes.isEmpty) {
          return _buildShimmer(context);
        }

        // final newPosts = state.routes;
        if (state.status == BlocStatus.fetched) {
          // _searchedRoutes.addAll(newRoutes);
          _searchedRoutes = state.routeModels;
        }
        // if (_searchedRouteCubit.getPage % 4 == 0) {
        //   _trendingPosts.addAll(newPosts);
        // }
        // if (!(_searchedRouteCubit.getPage % 4 == 0)) {
        // _searchedRoutes.addAll(newRoutes);
        // }

        return _searchedRoutesBuilder(context);
      },
      listener: (context, state) {
        if (state.status == BlocStatus.fetchFailed &&
            // _trendingPosts.isNotEmpty) {
            _searchedRoutes.isNotEmpty) {
          context.showSnackBar(SnackBar(
            content: Text(state.error ?? "Internet Connection Error!"),
          ));
        }
      },
      buildWhen: (previous, current) =>
          // current.status == BlocStatus.fetched && previous != current,
          current.status == BlocStatus.fetched &&
          previous.status != BlocStatus.fetched,
    );
  }

  _searchedRoutesBuilder(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: _searchedRoutes.length,
        (context, index) {
          final route = _searchedRoutes[index];
          return RouteInfoCardWidget(
            route: route,
            onRoutePressed: (route) {
              context.pushNamed(RouteLists.routeDetailPage, arguments: route);
            },
            onAgencyPressed: (route) {
              context.pushNamed(RouteLists.publicAgencyProfile,
                  arguments: route.agency);
            },
          );
        },
      ),
    );
  }

  _buildShimmer(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
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
      childCount: 5,
    ));
  }
}

class LocationCityChoiceWidget extends StatefulWidget {
  const LocationCityChoiceWidget({
    super.key,
    required ValueNotifier<City?> locationValueNotifier,
    required CityAutocompleteController locationAutoCompleteController,
    this.hintText,
    this.labelText,
    this.initialLocation,
  })  : _locationValueNotifier = locationValueNotifier,
        _locationAutoCompleteController = locationAutoCompleteController;

  final ValueNotifier<City?> _locationValueNotifier;
  final CityAutocompleteController _locationAutoCompleteController;
  final String? hintText;
  final String? labelText;
  final City? initialLocation;

  @override
  State<LocationCityChoiceWidget> createState() =>
      LocationCityChoiceWidgetState();
}

class LocationCityChoiceWidgetState extends State<LocationCityChoiceWidget> {
  String? _labelText;
  String? _hintText;

  @override
  void initState() {
    super.initState();
    _labelText = widget.labelText;
    _hintText = widget.hintText;
  }

  setLabelText(String label) {
    debugPrint("LABEL TEXT CHANGED!");

    _labelText = label;
    setState(() {});
  }

  setHintText(String hint) {
    debugPrint("HINT TEXT CHANGED!");
    _hintText = hint;
    setState(() {});
  }

  swapLocation(City? city) {
    widget._locationAutoCompleteController.text = city?.name ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.symmetric(horizontal: AppInsets.inset30),
      shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      child: ValueListenableBuilder(
        valueListenable: widget._locationValueNotifier,
        builder: (BuildContext context, City? value, Widget? child) {
          return CityAutocomplete(
            cities: App.cities,
            controller: widget._locationAutoCompleteController,
            initialValue: widget.initialLocation?.name,
            onSelected: (city) {
              widget._locationValueNotifier.value = city;
              setState(() {});
            },
            // border: InputBorder.none,
            labelText: _labelText,
            hintText: _hintText,
          );
        },
      ),
    );
  }
}

class OriginDestinationSwipeWidget extends StatefulWidget {
  const OriginDestinationSwipeWidget(
      {super.key, this.initialOrigin, this.initialDestination});

  final City? initialOrigin;
  final City? initialDestination;

  @override
  State<OriginDestinationSwipeWidget> createState() =>
      OriginDestinationSwipeWidgetState();
}

class OriginDestinationSwipeWidgetState
    extends State<OriginDestinationSwipeWidget> {
  final CityAutocompleteController _originContorller =
      CityAutocompleteController();
  final CityAutocompleteController _destinationContorller =
      CityAutocompleteController();

  swipeLocation() {
    // _locationAutoCompleteController
    String origin = _originContorller.text;
    _originContorller.text = _destinationContorller.text;
    _destinationContorller.text = origin;
    // print("origin = ${origin?.name} destination = ${dest?.name} ");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Origin
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: AppInsets.inset30),
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          child: CityAutocomplete(
            cities: App.cities,
            controller: _originContorller,
            initialValue: widget.initialOrigin?.name,
            onSelected: (city) {
              // widget._locationValueNotifier.value = city;
            },
            labelText: "Origin",
            hintText: "Select Origin",
          ),
        ),
        const SizedBox(height: 16),

        /// Destination
        Card.filled(
          margin: const EdgeInsets.symmetric(horizontal: AppInsets.inset30),
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          child: CityAutocomplete(
            cities: App.cities,
            controller: _destinationContorller,
            onSelected: (city) {},
            initialValue: widget.initialDestination?.name,
            labelText: "Destination",
            hintText: "Select Destination",
          ),
        )
      ],
    );
  }
}

///
///
/// Swap
